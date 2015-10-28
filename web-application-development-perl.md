# PerlによるWebアプリケーション開発

# Hatena::Newbie

WAFの実例を通じて実際の雰囲気を掴みましょう。

## 前提
- CPANにはWAFの一部を実装したモジュールがひと通り
    - それらを組み合わせればよくなった
    - 最近のはてなではいわゆるWAFは使っていない
- 「MVCのパターン」や「Webアプリ開発の勘所」を研修用WAFのHatena::Newbieで学ぶ

## 目次
- [Hatena::Newbieとは](#intro)
- [Intern::Bookmarkとは](#intern-bookmark)
- [ブックマーク一覧を作ってみよう](#intern-bookmark-list)
    - [URI設計](#intern-bookmark-list-uri)
    - [Controllerを書こう](#intern-bookmark-list-controller)
    - [Viewを書こう](#intern-bookmark-list-view)
    - [テストを書こう](#intern-bookmark-list-test)
- [他の機能も作ってみよう](#intern-bookmark-others)
- [URIを変更してみよう](#intern-bookmark-other-uri)

## Hatena::Newbieとは <a name="intro"></a>

- はてな研修用WAF
    - 研修用にハマりどころを出来るだけ無くして、簡単に読めるフレームワークに
- はてなのWAFの歴史
    - Hatena → Hatena2 → Ridge → フレームワークなし(?)
    - 少し前のプロジェクトでは使われています(Bookmark, Star, Ugomemo)
- perl-Intern-Bookmarkとperl-Intern-Diaryはこのフレームワークに基づく

ではこれから`bookmark.pl`の機能をWebアプリケーション化していきましょう。以下のようにするとHatena::Newbieをフレームワークとした真っ新なプロジェクトを開始できます。

```
$ git clone https://github.com/hatena/Hatena-Newbie Intern-Bookmark
$ cd Intern-Bookmark
$ script/generate Intern::Bookmark
```

このあとの説明はCLI版の実装はおわっている前提で進めていきます。すべての作業を終えた完成形のお手本を手元に`git clone`して参考にしてください。(お手本はユーザ認証まで作りこんであったり、この資料でカバーしていない範囲の実装も含んでいます。)

```
$ git clone https://github.com/hatena/perl-Intern-Bookmark Intern-Bookmark
$ cd Intern-Bookmark
$ script/setup_db.sh
```

## Intern::Bookmarkとは <a name="intern-bookmark">
はてな研修用WAFのHatena::Newbieを利用して作成したWebアプリの例です。

### ディレクトリ構成

フレームワークなども全部このディレクトリに入っているので少し多めですが以下の様な構成になっています。

```Bash
$ tree perl-Intern-Bookmark/
perl-Intern-Bookmark/
├── cpanfile
├── db # DB設定ファイル
│   └── schema.sql
├── lib # Perlモジュール
│   └── Intern
│       ├── Bookmark
│       │   ├── Config
│       │   │   ├── Route
│       │   │   │   └── Declare.pm
│       │   │   └── Route.pm
│       │   ├── Config.pm
│       │   ├── Context.pm
│       │   ├── Engine
│       │   │   ├── API.pm
│       │   │   ├── Bookmark.pm
│       │   │   └── Index.pm
│       │   ├── Model
│       │   │   ├── Bookmark.pm
│       │   │   ├── Entry.pm
│       │   │   └── User.pm
│       │   ├── Request.pm
│       │   ├── Service
│       │   │   ├── Bookmark.pm
│       │   │   ├── Entry.pm
│       │   │   └── User.pm
│       │   ├── Util.pm
│       │   └── View
│       │       └── Xslate.pm
│       └── Bookmark.pm
├── README.md
├── script # 様々なスクリプトファイル
│   ├── app.psgi
│   ├── appup
│   ├── appup.pl
│   └── setup_db.sh
├── static # 静的ファイル(画像, css, js)
│   └── css
│       └── style.css
├── t # テスト置き場
│   ├── engine
│   │   ├── api.t
│   │   ├── bookmark.t
│   │   └── index.t
│   ├── lib
│   │   └── Test
│   │       └── Intern
│   │           ├── Bookmark
│   │           │   ├── Factory.pm
│   │           │   └── Mechanize.pm
│   │           └── Bookmark.pm
│   ├── model
│   │   ├── bookmark.t
│   │   ├── entry.t
│   │   └── user.t
│   ├── object
│   │   ├── config.t
│   │   ├── dbi-factory.t
│   │   └── util.t
│   └── service
│       ├── bookmark.t
│       ├── entry.t
│       └── user.t
└── templates # テンプレート(View)置き場
    ├── bookmark
    │   ├── add.html
    │   └── delete.html
    ├── bookmark.html
    ├── index.html
    └── _wrapper.tt
```

Webアプリケーションとして重要となる`lib`内の構成要素は以下のとおりです。
- `lib/Intern/Bookmark.pm`
    - Controllerの中心をなすディスパッチャ
- `lib/Intern/Bookmark/Config.pm`
    - アプリケーションの設定はここに
- `lib/Intern/Bookmark/Config/Route.pm`
    - エンドポイントURIの設定はここに
- `lib/Intern/Bookmark/Context.pm`
    - アプリケーションのコンテキストクラス
    - リクエスト、レスポンス、ルーティングなどの情報を持ち、ControllerとViewの中継などを行う
    - 1リクエストごとに作成され、処理が終わると破棄される
- `lib/Intern/Bookmark/Engine/Index.pm`
    - Controller
    - 中にアクションを書く
- `templates/index.html`
    - View
    - HTMLや`Text::Xslate`などを使って書く


### テストサーバの起動

```
$ script/appup
11:13:18 app.1      | Watching lib script/lib script/app.psgi for file updates.
11:13:19 app.1      | HTTP::Server::PSGI: Accepting connections at http://0:3000
# http://localhost:3000/ でアクセスできる
```


## ブックマーク一覧を作ってみよう <a name="intern-bookmark-list"></a>

### URI設計 <a name="intern-bookmark-list-uri"></a>

実装に入る前にまずはURIを設計します。

#### Bookmarkアプリでの要件
Bookmarkアプリでの機能は以下のとおりです。
- 一覧
- 表示
- 作成
- 削除

これらに対応するURIは以下のように設計できます。

|メソッド| パス                                  | 動作                       |
|------|-----------------------------------------|----------------------------|
|`GET` | `/`                                     | ブックマーク一覧           |
|`GET` | `/bookmark?url=url`                     | ブックマークのパーマリンク |
|`POST`| `/bookmark/add?url=url&comment=comment` | ブックマークの追加         |
|`POST`| `/bookmark/delete?url=url`              | ブックマークの削除         |


### Controllerを書こう <a name="intern-bookmark-list-controller"></a>
以下のURI設計におけるブックマーク一覧(`/`)を例として、Controllerを作っていきます。


#### まずはHello Worldから
まずはURIとControllerの紐付けをします。`lib/Intern/Bookmark/Config/Route.pm`が紐付けの役割を担うので以下のように書きます。これによって`/`にアクセスが来たら、`Intern::Bookmark::Engine::Index`の`default`メソッドに処理がいくようになります。

```Perl
# lib/Intern/Bookmark/Config/Route.pm

sub make_router {
    return router {
        connect '/' => {
            engine => 'Index',
            action => 'default',
        };
    };
}
```

次にControllerの実装をします。先ほど指定したControllerに処理を書いていきます。

```Perl
# lib/Intern/Bookmark/Engine/Index.pm

package Intern::Bookmark::Engine::Index;
use strict;
use warnings;

sub default {
    my ($class, $c) = @_;

    $c->res->content_type('text/plain');
    $c->res->content('Welcome to the Hatena world!');
}

1;
```

- `$class` : Controllerのクラス (`Intern::Bookmark::Engine::Index`)
- `$c` : コンテキストオブジェクト (`Intern::Bookmark::Context`のインスタンス)
- `$c->res->content`で出力内容を直接設定


#### ブックマーク一覧のControllerを作る
- `bookmark.pl`の`list_bookmarks()`に対応
- Controllerがやるべきこと
    - ユーザのブックマーク一覧を取得
    - 取得したブックマーク一覧を出力(Viewに渡す)

```Perl
# lib/Intern/Bookmark/Engine/Index.pm

sub default {
    my ($class, $c) = @_;

    # ひとまずユーザはtarao決め打ち
    my $user = Intern::Bookmark::Service::User->find_user_by_name($c->dbh, {
        name => 'tarao',
    });

    # ブックマーク一覧を取得
    my $bookmarks = Intern::Bookmark::Service::Bookmark->find_bookmarks_by_user($c->dbh, {
        user => $user
    });
    Intern::Bookmark::Service::Bookmark->load_entry_info($c->dbh, $bookmarks);

    # Viewを指定し、ブックマーク一覧をViewに渡す
    $c->html('index.html', {
        bookmarks => $bookmarks,
    });
}
```

- ユーザのブックマーク一覧の取得(モデルへのアクセス)はCLIのときと同じ
- ビュー指定とデータの受け渡し
    - `$c->html`でviewのファイルの指定と、データの受け渡しができる


#### Controllerのロジックを分離する
- いろんなページで使うロジックは個別のControllerからは分離しておくべき
    - 上のコードの場合、ユーザの取得はいろんなページで使うだろう
- ユーザの取得を`$c`のメソッドとして定義してみる

```Perl
# lib/Intern/Bookmark/Context.pm

sub user {
    my ($self) = @_;
    my $user = Intern::Bookmark::Service::User->find_user_by_name($self->dbh, {
        name => 'tarao',
    });
}
```

先ほどの`Index.pm`は以下のようにできます。
```Perl
# lib/Intern/Bookmark/Engine/Index.pm

sub default {
    my ($class, $c) = @_;

    my $bookmarks = Intern::Bookmark::Service::Bookmark->find_bookmarks_by_user($c->dbh, {
        user => $c->user
    });
    Intern::Bookmark::Service::Bookmark->load_entry_info($c->dbh, $bookmarks);
    $c->html('index.html', {
        bookmarks => $bookmarks,
    });
}
```

- Controllerにはロジックを書かないくらいの気持ちでいると、綺麗に書ける(かも)
- どうしてもロジックが入ってくる場合は
    - あんまり気にしすぎても仕方ないのでバランスを取って
    - 大規模になるとアプリケーション層を作って分離したり (MMVC)


### Viewを書こう <a name="intern-bookmark-list-view"></a>
- Controllerで`index.html`を指定しているので、`templates/index.html`が使われる
    - このファイルにHTMLと`Text::Xslate`(TTerse + `Text::Xslate::Bridge::TT2`)で書く


#### `Text::Xslate` (TTerse) 入門
- `Text::Xslate`
    - テンプレートエンジン
- Perlのテンプレートエンジンは他にも沢山
    - `HTML::Template`、`Template::Toolkit`など

##### 変数呼び出し
- Controllerで渡した変数が使える
```HTML
[% foo.bar %]
```

##### 繰り返し処理
- 配列に対する繰り返し
```HTML
[% FOREACH item IN items %] ... [% END %]
```

##### 分岐処理
```HTML
[% IF x %] ... [% ELSE %] ... [% END %]
```

##### URIエスケープ
```HTML
<a href="http://b.hatena.ne.jp/search/tag?q=[% uri_escape(word) %]">
```

##### 外部テンプレートからの読み込み
```HTML
[% INCLUDE "header.html" %]
```

##### マクロ
```HTML
[% MACRO show_title(title) BLOCK %]
<h1>[% title %]</h1>
[% END %]
```

##### 参考
- [TTerseの文法][cpan-text-xslate-syntax-tterse]
- [`Bridge::TT2`で追加される機能][cpan-text-xslate-bridge-tt2]
    - [ここのvmethods][cpan-template-manual-vmethods]が増える


#### ブックマーク一覧のViewを作る
Controllerで指定したViewは`templates/index.html`でしたね。そこに追加して行きましょう。

```HTML
[% IF bookmarks.size() %]
    [% FOR bookmark IN bookmarks %]
      [% SET entry = bookmark.entry %]
      <a href="/bookmark?url=[% uri_escape(entry.url) %]">[% entry.title %]</a>
      <p>[% bookmark.comment %]</p>
    [% END %]
[% ELSE %]
    <p>ブックマークがまだありません</p>
[% END %]
```

- Controllerから渡した`bookmarks`にアクセスできている
- `Text::Xslate`は自動でHTMLをエスケープしてくれている
    - 逆にエスケープをオフにする時はXSSに注意


### テストを書こう <a name="intern-bookmark-list-test"></a>
ここまでで機能は出来上がりましたが、作った機能にはテストを書きましょう。ここではHello Worldページの簡単なテストだけ書きます。詳しくはお手本コードを参照して、テストを書くようにしてください。

```Perl
# t/engine/index.pm

package t::Intern::Bookmark::Engine::Index;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use parent qw(Test::Class);

use Test::Intern::Bookmark;
use Test::Intern::Bookmark::Mechanize qw(create_mech);
use Test::Intern::Bookmark::Factory qw(create_user);

use Test::More;

sub _get : Test(2) {
    subtest 'guestアクセス' => sub {
        my $mech = create_mech; # Test::WWW::Mechanizeを利用
        $mech->get_ok('/', '/にアクセスできるかのテスト');
        $mech->title_is('Intern::Bookmark::Top', 'titleのテスト');
        $mech->content_contains('Welcom to the Hatena world!', '表示内容のテスト');
    };

    subtest 'login状態でアクセス' => sub {
        my $user = create_user;
        my $mech = create_mech(user => $user);
        $mech->get_ok('/');
    };
}


__PACKAGE__->runtests;

1;
```

- [`Test::WWW::Mechanize`][cpan-test-www-mechanize]
    - Webアプリのテストによく利用されるモジュール
    - [`WWW::Mechanize`][cpan-www-mechanize]のテスト用クラス
    - PSGIなWebアプリの場合は[`Test::WWW::Mechanize::PSGI`][cpan-test-www-mechanize-psgi]が利用できる
    - 詳しくは`t/Test/Intern/Bookmark/Mechanize.pm`


## 一旦おさらい

- Hatena::Newbieでの開発の流れは
    1. URIを決める
    2. URIとControllerの紐付けを定義する
    3. 紐付けたControllerを書いて、Viewにデータを渡す
    4. 渡されたデータを使って、対応するViewを書く (HTML、`Text::Xslate`など)


## 他の機能も作ってみよう <a name="intern-bookmark-others"></a>

今度はブックマーク追加機能を作ってみましょう。要件は以下のようにしてみます。
- `GET /bookmark/add` : ブックマーク追加のフォーム
- `POST /bookmark/add` : ブックマーク追加処理 + 完了後にリダイレクト

### URIとControllerの紐付けを作る

```Perl
# Intern/Bookmark/Config/Route.pm

sub make_router {
    return router {
        connect '/' => {
            engine => 'Index',
            action => 'default',
        };

        # bookmark一覧のURIとController紐付け
        connect '/bookmark/add' => {
            engine => 'Bookmark',
            action => 'add_get',
        } => { method => 'GET' };
        connect '/bookmark/add' => {
            engine => 'Bookmark',
            action => 'add_post',
        } => { method => 'POST' };
    };
}
```

- `{ method => '...' }`とすることでHTTPメソッドを制限することが可能

### Controllerを作る
- 指定したControllerは
    - フォーム : `Intern::Bookmark::Engine::Bookmark`の`add_get()`
    - 追加処理 : `Intern::Bookmark::Engine::Bookmark`の`add_post()`

```Perl
# lib/Intern/Bookmark/Engine/Bookmark.pm

sub add_get {
    my ($class, $c) = @_;

    my $url = $c->req->parameters->{url};

    my ($bookmark, $entry);
    if ($url) {
        # 編集時はurlが存在
        $entry = Intern::Bookmark::Service::Entry->find_entry_by_url($c->dbh, {
            url => $url,
        });
        $bookmark = Intern::Bookmark::Service::Bookmark->find_bookmark_by_user_and_entry($c->dbh, {
            user  => $c->user,
            entry => $entry,
        }) if $entry;
    }

    $c->html('bookmark/add.html', {
        bookmark => $bookmark,
        entry    => $entry,
    });
}

sub add_post {
    my ($class, $c) = @_;

    my $url = $c->req->parameters->{url};
    my $comment = $c->req->string_param('comment');

    Intern::Bookmark::Service::Bookmark->add_bookmark($c->dbh, {
        user    => $c->user,
        url     => $url,
        comment => $comment,
    });

    $c->res->redirect('/');
}

```

- パラメータは`$c->req->parameters->{url}`のようにして取り出す
    - クエリパラメータ(`GET /bookmark?url=...`)
    - `POST`のボディのパラメータ(`<form>`の`<input>`の`name`属性でパラメータ名を指定)
- リダイレクト先の指定は`$c->res->redirect()`で可能


### Hatena::NewbieのリクエストとレスポンスのAPI
リクエストを処理するオブジェクトやレスポンスを処理するオブジェクトは`$c`から取得できます。

- `$c->req` : `Intern::Bookmark::Request`オブジェクト
    - `$c->req->param($name)` : `GET`や`POST`で渡ってくる(クエリやボディの)パラメータを取得
    - `$c->req->uri` : リクエストURIオブジェクトを取得
    - `$c->req->header($name)` : リクエストヘッダを取得
- `$c->res` : `Plack::Response`オブジェクト
    - `$c->html($file_name, $args)` : Viewの指定
    - `$c->res->content_type($content_type)` : `Content-Type`ヘッダの指定
    - `$c->res->content($content)` : レスポンスボディの指定(Viewを作らず直に文字列を返す)
    - `$c->res->redirect($uri_or_path)` : 特定のURIもしくはパスにリダイレクト
などなど

詳しくは以下を読みましょう
- [`Plack::Request`][cpan-plack-request]
- [`Plack::Response`][cpan-plack-response]

### Viewを書く
- `GET /bookmark/add` にはテンプレートが必要
- Controllerで指定したテンプレートは`templates/bookmark/add.html`

```HTML
<form method="POST" action="/bookmark/add">
  <dl>
    <dt>URL</dt>
    <dd><input type="text" name="url"></dd>
    <dt>Comment</dt>
    <dd><input type="text" name="comment"></dd>
  </dl>
  <p><input type="submit"></p>
</form>
```

- `/bookmark/add`に`POST`する`<form>`
    - `<input>`で指定されている、`url`, `comment`をパラメータとして`POST`


他の機能はこれまで説明した機能を用いて実装できるので、Intern::Bookmarkを見てください!


## URIを変更してみよう <a name="intern-bookmark-other-uri"></a>
URIとControllerの紐付けには`Router::Simple`を用いています。そのためいろいろなURIを使うことが出来ます。

例
```Perl
connect '/bookmark/{id}', { engine => 'Bookmark', action => 'default' }
# /bookmark/1234 等でアクセス可能
# $c->req->path_parameters->{id} でパラメータを取り出せる
```

以下の書籍などを参考にして、URIの設計をしてみましょう。

- 参考書籍
    - Webを支える技術 5章


## この章のまとめ
- Hatena::Newbieによる開発の流れは
     - URIを決める
     - URIとControllerを紐付ける
     - 紐付けたControllerを書いて、Viewにデータを渡す
     - 渡されたデータを使って、対応するViewを書く
- フレームワークを用いれば面倒な部分を気にせずにWebアプリが書ける
     - またフレームワーク自体もモジュールの組み合わせでシンプルに実装できる
- ビジネスロジックはできるだけModelに入れてControllerに書かないくらいの気持ちでいたほうがいい(かも)


----


# Webアプリケーションにおけるセキュリティの基本 <a name="security"></a>
この章ではWebアプリケーションにおけるセキュリティの基本について話します。

## なぜセキュリティ?
- Webアプリを作るときはセキュリティを意識することが必須
- 脆弱性を作ると
    - ユーザがプライベートと思っているものに他者からアクセスされてしまう
    - 特定ユーザしか編集できない情報を他者から勝手に編集されてしまう
    - など問題が多い

## 気をつけること
- Webアプリケーションには「あらゆる」ユーザー入力が想定される
    - あらゆるエンドポイントにあらゆるリクエストが飛んでくる可能性がある
- ユーザー入力のインプットとそのアウトプットに気を配る
    - 適切な入力値バリデーション(これはセキュリティというよりかはアプリケーションの作りの話)
    - 適切な出力エスケープ
        - 何がユーザー(外部)入力由来かを意識する

## 今回話すこと
- 攻撃方法は様々
- 今回はXSSについて
- さらに詳しくは「体系的に学ぶ 安全なWebアプリケーションの作り方　脆弱性が生まれる原理と対策の実践」を


## XSS
- XSSとはクロスサイトスクリプティング(Cross Site Scripting)の略
- ユーザの送ってきたスクリプトをページ内に埋め込まれて実行される脆弱性
- 様々な問題
    - 特定のユーザのログイン情報を抜き取る
    - サイトのページを改ざんされる

例えば今回のBookmarkアプリの一覧表示(`/`)で、ブックマークのコメントをユーザ入力のまま表示させてしまったとします。
```HTML
<!-- Text::Xslate では raw というフィルタに通すとHTMLエスケープされなくなる -->
<p>[% bookmark.comment | raw %]</p>
```

この場合以下のコメントに以下の文字列が入っていると、閲覧した人のブラウザ上でJavaScriptコードが実行されてしまいます。
```
<script>alert('XSS')</script>
```

- 根本的な対策
    - 出力時に適切なエスケープをすること
    - 今回の場合は、`Text::Xslate`が自動的にエスケープしてくれるので何もしなくて良い
    - ただし、明示的に`raw`でエスケープを抑制した場合は注意が必要

## 何が外部由来の入力か

「そりゃフォーム入力とかでしょ」

**他にもある!!**

- 周囲のWifiアクセスポイント一覧を出すWebサイト
- アップロードする画像のExifの中に`<script>`タグをしこむ
   - Exifの内容をエスケープせずにサイトに表示したらアウト

### 気をつけること

- 外部入力由来のデータに気をつける
    - テンプレートのオートエスケープ機構に頼る
    - SQLの組み立てはプレースホルダ必須
- 二重エスケープして `&lt;` とか出てしまうほうがマシ
    - それから対応を考えるでもいい

----


# おまけ1. PSGI/Plack <a name="psgi"></a>

## WebサーバとWebアプリケーションが共通のインターフェースを利用する

- サーバリクエスト、サーバレスポンスはサーバのインターフェイスに依存していたが、最近はサーバとアプリケーションがPSGIという仕様に従うように

![](http://cdn-ak.f.st-hatena.com/images/fotolife/s/shiba_yu36/20120712/20120712135246.png)

- WAFの「サーバとの対話を仲介、抽象化する」という機能は[`Plack`][cpan-plack]に実装されている
- サーバとアプリのインターフェースが決まり、組み換えが簡単に
    - これまではサーバごとにWAFが対応

![](http://cdn-ak.f.st-hatena.com/images/fotolife/s/shiba_yu36/20120712/20120712135247.png)


## PSGI概要
- WebサーバとWebアプリケーションの間の、リクエストレスポンスの**共通インターフェース仕様**
- これによりPSGIに対応したサーバ、アプリケーションがそれぞれ簡単に組み替え可能に
    - PSGIを喋るサーバ : `Starman`, `Starlet`, `HTTP::Server::PSGI`, `Corona`, `Twiggy` など
    - PSGIを喋るWAF : `Amon2`, `Mojolicious`, `Catalyst`, `Jifty` など
    - サーバにApache以外の選択肢が増えると嬉しい

### PSGIの簡単な仕様
- アプリケーション側は以下の仕様を満たすコードリファレンス(ハンドラ)
    1. 環境変数をハッシュ(`$env`)として受け取り
    2. レスポンスをPSGIに定められた形式の配列リファレンスで返す
- リクエストはハッシュリファレンスとして受け取る

    ```Perl
    my $env = {
                'psgi.version' => [1, 0],
                'psgi.url_scheme' => 'http',
                'psgi.input' => 'hoge',
                'psgi.errors' => '',
                'psgi.multithread' => 0,
                'psgi.multiprocess' => 0,
                'REQUEST_METHOD' => 'GET',
                'SCRIPT_NAME' => '/fuga',
                'PATH_INFO' => '/fuga',
                'QUERY_STRING' => 'id=1',
            };
    ```

- レスポンスは配列リファレンスとして返す

    ```Perl
    [
           200,
           [ 'Content-Type' => 'text/plain' ],
           [ "Hello World"],
    ]
    ```

- PSGIでHello World

    ```Perl
    my $app = sub {
        my $env = shift;
        return [
            '200',
            [ 'Content-Type' => 'text/plain' ],
            [ "Hello World" ],
        ];
    }
    ```



## Plack
- PlackとはWebアプリケーション側PSGI実装
    - `Plack::Request` : リクエスト操作
        - `$env`からクエリパラメータを取り出すなど
    - `Plack::Response` : レスポンス操作
        - ステータスコードやボディを指定してレスポンス用配列リファレンスを作るなど
- PSGIの実装としてPlackがあることによって、簡単にリクエストやレスポンスを扱える
- その他開発に便利なツールも(`plackup`など)
- 面倒なリクエストレスポンス処理などはPlackがやってくれるので、**WAFも簡単に作れる**

    ```Perl
    my $app = sub {
        my $env = shift;
        my $req = Plack::Request->new($env);
        warn $req->parameters->{query};

        my $res = $req->new_response(200); # new Plack::Response
        $res->content_type('text/html');
        $res->body("Hello World");

        return $res->finalize;
    }
    ```

- 仕様が単純なため、アプリケーションの前後に処理を仕込むのも容易

    ```Perl
    # 先ほどの $app に処理を仕込む
    # リクエストとレスポンスを書き換え
    my $app_with_hook = sub {
       my $env = shift;

       # ... $envに対して操作する
       $env->{REMOTE_ADDR} = '1.2.3.4'; # REMOTE_ADDR書き換えちゃう

       my $res = $app->($env);

       # ... $resに対して操作する
       $res->[0] = '404'; # 勝手に404にしちゃう

       return $res;
    };
    ```
- `Plack::Middleware::*`
    - よく使う前処理や後処理をライブラリ化したもの
    - 後ほど出てくるはてなOAuth認証の例もこれの一つ
    - 他にもアクセスログや実行時間の記録などいろいろある
    - この組み合わせだけでフレームワークがやるべき大部分が実現可能


## まとめ
- PSGIというサーバとアプリの共通インターフェース
    - リクエストをハッシュリファレンス、レスポンスを配列リファレンスとして表現
    - 簡単に組み合わせを変えることができる
- PlackというPSGIのアプリ側実装によって簡単にWAFのようなものが作れる
    - 入れ子呼び出し構造による高い拡張性
    - `Plack::Middleware::*`で組み合わせ自在


----


# おまけ2 : `Plack`、`Router::Simple`、`Text::Xslate`を利用した簡易WAF
- 以下のように使えるWAFを作ってみる

```Perl
# app.psgi
use strict;
use warnings;

use WAF;

any '/' => sub {
    my $c = shift;
    $c->render('index.tt', { name => 'shiba_yu36' });
};

get '/hoge' => sub {
    my $c = shift;
    $c->render('hoge.tt', { name => 'shiba_yu36' });
};

waf;

__DATA__

@@ index.tt
<html>
  <body>
    Hello, [% name %]
  </body>
</html>

@@ hoge.tt
<html>
  <body>
    Hoge, [% name %]
  </body>
</html>
```

- `Plack`、`Router::Simple`、`Text::Xslate`など、WAFのパーツは存在
- 100行足らずのコードで簡単に実装可能

```Perl
package WAF;
use strict;
use warnings;

use Exporter qw(import);
our @EXPORT = qw(get post any waf);

use Router::Simple;
our $router = Router::Simple->new();

use Data::Section::Simple;
our $data_section = Data::Section::Simple->new(caller(0));

# ----- Controller -----
sub get {
    my ($url, $action) = @_;
    any($url, $action, ['GET']);
}

sub post {
    my ($url, $action) = @_;
    any($url, $action, ['POST']);
}

sub any {
    my ($url, $action, $methods) = @_;
    my $opts = {};
    $opts->{method} = $methods if $methods;
    $router->connect($url, { action => $action }, $opts);
}

sub waf {
    return my $app = sub {
        my $env = shift;

        my $context = WAF::Context->new(
            env          => $env,
            data_section => $data_section,
        );

        if (my $p = $router->match($env)) {
            $p->{action}->($context);
            return $context->res->finalize;
        } else {
            return [404, [], ['not found']];
        }
    };
}

# ------ Controllerで利用するAPI ------
package WAF::Context;
use Plack::Request;
use Class::Accessor::Lite::Lazy (
    new => 1,
    ro => [qw(env data_section)],
    ro_lazy => [qw(req res)],
);
use Data::Section::Simple qw(get_data_section);

sub _build_req {
    return Plack::Request->new(shift->env);
}

sub _build_res {
    return shift->req->new_response(200);
}

sub render {
    my ($self, $tmpl_name, $args) = @_;
    my $str  = $self->data_section->get_data_section($tmpl_name);
    my $body = WAF::View->render_string($str, $args);
    return $self->res->body($body);
}

# -------- View ---------
package WAF::View;
use Text::Xslate;

our $tx = Text::Xslate->new(
    syntax => 'TTerse',
    module => [ qw(Text::Xslate::Bridge::TT2Like) ],
);

sub render_string {
    my ($class, $str, $args) = @_;
    return $tx->render_string($str, $args);
}

1;
```


----


# おまけ3. インスタンスキャッシュ

```perl
$self->{_created} ||= eval {
    Hatena::Newbie::Util::datetime_from_db($self->{created});
};
```

- 二度目の呼び出しでは以前の呼び出しで生成したオブジェクトを返すことで高速化している
- キャッシュしてはいけないものをキャッシュしてしまうと、分かりづらいバグになるので注意
 - 現在時刻を返すメソッドでキャッシュしてしまう……とか
- 偽と評価されるもの(`undef`を除く)をキャッシュしたい場合は`||=`の代わりに`//=`

# 課題3
- CLI版Intern::DiaryをWebアプリケーションにして下さい

## (必須) 記事の表示
- すでに書かれたdiaryの記事をブラウザで読めるように
    - テンプレートをちゃんと使って
    - 設計を意識しよう
    - 良いURI設計をしてみよう
- ページャを実装
    - SQLの`OFFSET`, `LIMIT`と`?page=`というクエリパラメータを使う
    - <strong>明日の課題に繋がるので必須</strong>

## (必須) 記事作成/編集/削除

- ブラウザで記事を書けるように
- ブラウザで記事を更新できるように
- ブラウザで記事を削除できるように

## (オプション) 追加機能

以下のような追加機能をできる限り実装してみてください。

- 例)
    - 認証 (Hatena/Twitter OAuth)
    - フィードを吐く (Atom, RSS)
    - デザイン
    - 管理画面
    - いろいろ貼り付け機能
    - その他自分で思いついたものがあれば

## (オプション) 品質向上

Hatena::Newbie(とお手本のIntern::Bookmark)は分かりやすさのためにたとえば以下のような点の実装を省略していて、そのままプロダクションコードとして使える品質にはなっていません。どうなっているべきか考えてきちんとしてみてください。WAF部分に手を加える必要があるかもしれません。

- 例)
    - DB書き込み時のトランザクション
    - DBへの接続のしかた
    - 並行にリクエストがやってきてもだいじょうぶか
    - CSRF対策

## 注意

- WAF自体のコードもプロジェクト内に入っています
    - いろんなCPANモジュールを使ってますがそれぞれ
        - `perldoc Module名`でドキュメントが見られる
        - `perldoc -m Module名`でコードが見られる
- ハマったらどういうふうにWAFができているか調べてみるのも良いです
- 全然分からなかったらすぐに人に聞きましょう


----


# 参考 : Hatena::Newbieのファイル構成と役割
```Bash
Intern-Diary/
├── cpanfile
├── db # DB設定ファイル
│   └── schema.sql
├── lib # Perlモジュール
│   └── Intern
│       ├── Diary
│       │   ├── Config
│       │   │   ├── Route # ルーティングのルールを書くクラス
│       │   │   │   └── Declare.pm
│       │   │   └── Route.pm
│       │   ├── Config.pm # 環境変数によって設定を切り替えるためのクラス(Config::ENV)
│       │   ├── Context.pm # アプリケーションのいろいろな場所で使えるクラス
│       │   ├── Engine # Controller置き場
│       │   │   └── Index.pm
│       │   ├── Request.pm # リクエストを扱うクラス(Plack::Requestの子クラス)
│       │   ├── Util.pm
│       │   └── View
│       │       └── Xslate.pm # Viewのクラス(Xslateのオプションを決めている)
│       └── Diary.pm # フレームワークの中核(ディスパッチなど)
├── README.md
├── script # 様々なスクリプトファイル
│   ├── app.psgi
│   ├── appup # ローカル開発用スクリプト
│   ├── appup.pl
│   └── setup_db.sh # ローカルDBセットアップ用スクリプト
├── t # テスト置き場
│   ├── engine
│   │   └── index.t
│   ├── lib
│   │   └── Test
│   │       └── Intern
│   │           ├── Diary
│   │           │   └── Mechanize.pm
│   │           └── Diary.pm
│   └── object
│       ├── config.t
│       ├── dbi-factory.t
│       └── util.t
└── templates # テンプレート(View)置き場
    ├── index.html
    └── _wrapper.tt
```


----


# 参考：ユーザ認証層

- [はてなOAuth認証][hatena-oauth]を使う場合

```Perl
# cpanfile

...

requires 'Plack::Middleware::HatenaOAuth';
```

```Perl
# script/app.psgi

...

builder {
    ...

    requires LWP::UserAgent;

    enable 'HatenaOAuth',
        consumer_key       => config->param('hatena_oauth.consumer_key'),
        consumer_secret    => config->param('hatena_oauth.consumer_secret'),
        login_path         => '/login',
        ua                 => LWP::UserAgent->new;

    $app;
};
```

```Perl
# lib/Intern/Bookmark/Config.pm

...

config default => {
    ...

    'hatena_oauth.consumer_key'    => 'XXXXXXXXXXXXXXXX',
    'hatena_oauth.consumer_secret' => 'XXXXXXXXXXXXXXXXXXXXXXXXXXXX',
}
```

----


# 参考資料
- https://metacpan.org/module/Router::Simple
- https://metacpan.org/module/Plack
- https://metacpan.org/module/Text::Xslate


----


<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/2.1/jp/"><img alt="クリエイティブ・コモンズ・ライセンス" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/2.1/jp/88x31.png" /></a><br />この 作品 は <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/2.1/jp/">クリエイティブ・コモンズ 表示 - 非営利 - 継承 2.1 日本 ライセンスの下に提供されています</a>。

[cpan-text-xslate-syntax-tterse]: https://metacpan.org/module/Text::Xslate::Syntax::TTerse
[cpan-text-xslate-bridge-tt2]: https://metacpan.org/module/Text::Xslate::Bridge::TT2
[cpan-template-manual-vmethods]: https://metacpan.org/module/Template::Manual::VMethods
[cpan-www-mechanize]: https://metacpan.org/module/WWW::Mechanize
[cpan-test-www-mechanize]: https://metacpan.org/module/Test::WWW::Mechanize
[cpan-test-www-mechanize-psgi]: https://metacpan.org/module/Test::WWW::Mechanize::PSGI

[cpan-plack]: https://metacpan.org/module/Plack
[cpan-plack-request]: https://metacpan.org/module/Plack::Request
[cpan-plack-response]: https://metacpan.org/module/Plack::Response
[cpan-formvalidator-simple]: https://metacpan.org/module/FormValidator::Simple

[hatena-oauth]: http://developer.hatena.ne.jp/ja/documents/auth/apis/oauth
