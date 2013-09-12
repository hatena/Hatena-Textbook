# 講義の中での位置づけ

- Perl
- DBアクセス
- Webアプリケーションフレームワーク ← イマココ!
- JavaScript

# 今日の内容

- 1. HTTPとURI
- 2. Webアプリケーション概説
- 3. MVC
- 4. Hatena::Newbie
- 5. Webアプリケーションにおけるセキュリティの基本
- おまけ1. PSGI/Plack
- おまけ2. Plack、Router::Simple、Text::Xslateを利用した簡易WAF
- 課題

- 以下、Web Application FrameworkはWAFと表記します

# 1.HTTPとURI

- Webアプリに入る前のウォーミングアップです
- 知ってる人は聞き流してください
- Webの基本になる２つの技術
    - HTTP
    - URI


## HTTP

- HTTP (Hypertext Transfer Protocol)
- 中身はテキストで書かれたヘッダと（あれば）ボディ
- リクエストとレスポンス


## リクエストとレスポンスの例

curl -v を使うと中身が見られます

```
curl -v http://hatenablog.com/
```

リクエスト
```
> GET / HTTP/1.1
> User-Agent: curl/7.24.0 (x86_64-apple-darwin12.0) libcurl/7.24.0 OpenSSL/0.9.8r zlib/1.2.5
> Host: hatenablog.com
> Accept: */*
```

レスポンス
```
< HTTP/1.1 200 OK
< Server: nginx/1.2.1
< Date: Fri, 15 Mar 2013 02:17:29 GMT
< Content-Type: text/html; charset=utf-8
< Transfer-Encoding: chunked
< Connection: keep-alive
< Vary: Accept-Language, Cookie
< P3P: CP="OTI CUR OUR BUS STA"
< X-Dispatch: Hatena::Epic::Blogs::Global#top
<
<html
  lang="ja"
  data-avail-langs="ja en"

...以下略
```

- <strong>ステートレス</strong>
    - 基本的にサーバはクライアントの状態に関する情報を保存しない
- メソッドが10程度しかないシンプルなプロトコル
    - シンプル故に実装が簡単
        - 故に広く普及
- メソッド GET, HEAD, PUT, POST, DELETE, OPTIONS, TRACE, CONNECT, PATCH, LINK/UNLINK
- Webアプリに必要なのはだいたい GET, HEAD, PUT, POST, DELETEくらい


## その中でも

- 日常的に使うのは GET, POSTのみ
- GET
    - リソースの取得
    - パラメータはURIに入れる
        - http://example.com/bookmark?id=1
- POST
    - リソースの作成、変更、削除
    - 変更、削除は本来ならPUT, DELETEメソッドでやるべき
    - HTMLのformがGET/POSTしかサポートしないためPOSTで代替するのが一般的
    - パラメータはURIとは別
        - URI長の制限を受けない


## ステータスコード

- HTTPレスポンスではステータスコードを返さなくてはならない
- リダイレクト、エラーハンドリング等を行うため、正しいステータスコードを返そう

### 代表的なステータスコード
- 200 OK
- 301 Moved Permanently
    - 恒久的なリダイレクト
- 302 Found
    - 一時的なリダイレクト
- 400 Bad Request
    - リクエストが間違い
    - クライアント側の問題
- 404 Not Found
    - リソースがない
- 500 Internal Server Error
    - アプリケーションのエラー
    - たぶん今日よく見ることになります
- 503 Service Unavailable
    - 落ちていると出る
    - よく見る


## URI

- URI (Uniform Resource Identifier)
    - 統一的なリソースを指し示すもの
- <strong>URIは名詞である</strong>
- OK: http://example.com/bookmark?id=1
- NG: http://example.com/bookmark?action=update&id=1
    - メソッドがURIに入ると、リファクタリングなどでURIが変わってしまう

### 良いURIとは
- ずっと変わらず同じ物を指す
- 構造がわかりやすい
    - http://shibayu36.hatenablog.com/entry/2012/07/30/210811

### 良いURIの恩恵
- 検索、ソーシャルブックマークなどでURIが分散しない
    - ずっと変わらず統一的なリソースを指し示す
    - PV、収益的にもGood!
- ユーザビリティを向上させる。
    - サイトの構造を意識させることができる

### HTTPとの関係

- URIは名詞、HTTPメソッドが動詞

```Bash
GET     http://example.com/bookmark/1 # 取得
POST    http://example.com/bookmark   # 作成
PUT     http://example.com/bookmark/1 # 変更
DELETE  http://example.com/bookmark/1 # 削除
```

## ここまでのまとめ

- HTTP
    - テキストベースのシンプルなプロトコル
    - GETでリソースの取得
    - POSTでリソースの作成･削除･更新
- URI
    - リソースを指し示すもの
    - クールなURIは変わらない
- URIは名詞、HTTPは動詞







# 2. Webアプリケーション概説

## Webアプリケーションの基本
- 動的なWebページを作りたい
    - ユーザに合わせたページ
    - ユーザがコンテンツを作成できる
    - などなど
- 基本的な動作
    - リクエストから何らかの表現（HTML等）を動的に作ってレスポンスを返す



## Webアプリケーションの構成要素
- 構成要素
    - Web server
    - Web Application Framework
    - Web Application(実際のコード)
- このあたりが組み合わさって一つのWebアプリケーションができる



## Webアプリケーションの動作

### 最もシンプルな図

<img src="http://cdn-ak.f.st-hatena.com/images/fotolife/s/shiba_yu36/20120712/20120712135243.png" />

- 動作
    - サーバが<em>クライアントから</em>HTTPリクエストを受けとる
    - サーバが<em>クライアントに</em>HTTPレスポンスを返す


### サーバとアプリケーションを分離した図

<img src="http://cdn-ak.f.st-hatena.com/images/fotolife/s/shiba_yu36/20120712/20120712135244.png" />

- 追加された動作
    - アプリケーションが<em>サーバから</em>サーバリクエストを受けとる
    - アプリｰションが<em>サーバに</em>サーバレスポンスを返す

- Webサーバプログラム
    - Apache, nginx, lighttpd, Tomcat...
- サーバリクエスト、サーバレスポンスはサーバのインターフェイス依存
    - mod_perl, FastCGI
    - 最近はサーバとアプリケーションがPSGIという仕様に従うように (おまけ1参照)


### WAFとWebアプリケーション処理を分離した図

<img src="http://cdn-ak.f.st-hatena.com/images/fotolife/s/shiba_yu36/20120712/20120712135245.png" />

- 追加された動作
    - WAFが<em>サーバから</em>サーバリクエストを受けとる
    - Webアプリケーション処理がWAFからリクエストオブジェクトを受けとる
    - Webアプリケーション処理がWAFにレスポンスオブジェクトを返す
    - WAFが<em>サーバに</em>サーバレスポンスを返す

- WAF
    - サーバとの対話を仲介、抽象化する
    - Webアプリケーションを記述するためのユーティリティを提供する

- Webアプリケーション処理
    - ビジネスロジック、DBアクセス、HTML生成など...

<strong>WAFがあることで処理の記述に専念できる</strong>



## ここまでのまとめ

- WebアプリケーションはHTTPリクエストに対し、動的にHTTPレスポンスを返す
- サーバ側はWebサーバ、WAF、Webアプリケーション処理に分けられる
- WAFを使えばWebアプリケーション処理の実装に集注できる

 

# 3. MVC

- 先ほどのWebアプリケーション処理の実装のパターンを解説します


## MVC

- Model, View, Controller
    - 表現とロジックを分離
        - デザイナーとエンジニアの作業分担を促進
        - テストがしやすくなる
    - GUIプログラミング、Webアプリケーション



## WebアプリケーションのMVC

<img src="http://cdn-ak.f.st-hatena.com/images/fotolife/s/shiba_yu36/20130315/20130315114505.png" />

- Model
    - 定義では: 抽象化されたデータと手続き
    - Webでは: ORマッパ、ビジネスロジックなど
    - はてなでは: DBI、DBIx::MoCo(最近のプロジェクトでは使ってない)、LWP::UserAgent、その他たくさん

- View
    - 定義では: リソースの表現
    - Webでは:　HTML, JSON, XML, 画像等を生成するもの
    - はてなでは: Text::Xslate、Template(最近のプロジェクトでは使ってない)、JSON::XSなど

- Controller
    - 定義では: ユーザの入力によって処理の流れを決定し、Model の API を呼び、View に必要なデータを渡す
    - Webでは: Webアプリケーションフレームワーク(の一部)
    - はてなでは: Router::Simple、Ridge(最近のプロジェクトでは使ってない)


## ここまでのまとめ
- MVCとはModel, View, Controllerにより表現とロジックを分離したもの
- 表現とロジックの分離により、デザイナーとエンジニアで作業が分担できる








# 4. Hatena::Newbie

## 前提
- CPANにはWAFの一部を実装したモジュールがひと通り
    - それらを組み合わせればよくなった
    - 最近のはてなではいわゆるWAFは使っていない

- 「MVCのパターン」や「Webアプリ開発の勘所」を学ぶために、研修用WAFのHatena::Newbieを利用します

## 目次
- 4.1 Hatena::Newbieとは
- 4.2 Intern-Bookmark-2013の構成
- 4.3 ブックマーク一覧を作ってみよう
    - 4.3.1 URI設計
    - 4.3.2 Controllerを書こう
    - 4.3.3 Viewを書こう
    - 4.3.4 テストを書こう
- 4.4 他の機能も作ってみよう
- 4.5 URIを変更してみよう

## 4.1 Hatena::Newbieとは
- はてな研修用WAF
    - 研修用にハマりどころを出来るだけ無くして、簡単に読めるフレームワークに
- はてなのWAFの歴史
    - Hatena -> Hatena2 -> Ridge -> フレームワークなし(?)
    - 少し前のプロジェクトでは使われています(Bookmark, Star, Ugomemo)

ではこれからbookmark.plをWebアプリにしていきましょう。
お手本コードはIntern-Bookmarkの続きとして実装しています。こちらのレポジトリではログインなどの機能も作ってあるので、これから紹介するコードとは少し異なることに注意してください。

以下の手順でcloneしてみてください。

```
git clone https://github.com/hatena/Intern-Bookmark-2013.git
```

## 4.2 Intern-Bookmark-2013の構成
はてな研修用WAFのHatena::Newbieを利用して作成したWebアプリの例です

### ディレクトリ構成

フレームワークなども全部このディレクトリに入っているので少し多めですが以下の様な構成になっています。
```Bash
$ tree Intern-Bookmark-2013/
Intern-Bookmark-2013/
├── README.md
├── cpanfile
├── db # DB設定ファイル
│ └── schema.sql
├── lib # Perlモジュール
│ └── Intern
│ ├── Bookmark
│ │ ├── Config
│ │ │ └── Route.pm
│ │ ├── Config.pm
│ │ ├── Context.pm
│ │ ├── DBI
│ │ │ └── Factory.pm
│ │ ├── DBI.pm
│ │ ├── Engine
│ │ │ ├── API.pm
│ │ │ ├── Bookmark.pm
│ │ │ └── Index.pm
│ │ ├── Error.pm
│ │ ├── Logger.pm
│ │ ├── Model
│ │ │ ├── Bookmark.pm
│ │ │ ├── Entry.pm
│ │ │ └── User.pm
│ │ ├── Request.pm
│ │ ├── Service
│ │ │ ├── Bookmark.pm
│ │ │ ├── Entry.pm
│ │ │ └── User.pm
│ │ ├── Util.pm
│ │ └── View
│ │   └── Xslate.pm
│ ├── Bookmark.pm
│ └── Plack
│   └── Middleware
│     └── HatenaOAuth.pm
├── script # 様々なscriptファイル
│ ├── app.psgi
│ ├── appup
│ └── setup.sh
├── static # 静的ファイル(画像, css, js)
│ ├── css
│ | └── style.css
├── t # テスト置き場
│ ├── engine
│ | ├── api.t
│ | ├── bookmark.t
│ │ └── index.t
│ ├── lib
│ │ └── Test
│ │   └── Intern
│ │     ├── Bookmark
│ │     │ ├── Factory.pm
│ │     │ └── Mechanize.pm
│ │     └── Bookmark.pm
│ ├── model
│ │ ├── bookmark.t
│ │ ├── entry.t
│ │ └── user.t
│ ├── model
│ | ├── config.t
│ | ├── dbi-factory.t
│ | ├── dbi.t
│ | └── util.t
│ └── service
│   ├── bookmark.t
│   ├── entry.t
│   └── user.t
└── templates # テンプレート(View)置き場
  ├── _wrapper.tt
  ├── bookmark
  | ├── add.html
  | └── delete.html
  ├── bookmark.html
  └── index.html
```

lib以下の重要な構成としては以下のとおり。
- lib/Intern/Bookmark.pm
    - ディスパッチャ、リクエストハンドリング、エラー処理などフレームワークの根幹のクラス
- lib/Intern/Bookmark/Config.pm
    - アプリケーションの設定はここに
- lib/Intern/Bookmark/Config/Route.pm
    - URLの設定はここに
- lib/Intern/Bookmark/Context.pm
    - アプリケーションのContextクラス
    - リクエスト、レスポンス、ルーティングなどの情報を持ち、ControllerとViewの中継などを行う
    - 1リクエストごとに作成され、処理が終わると破棄される
- lib/Intern/Bookmark/Engine/Index.pm
    - Controller。中にアクションを書く。
    - 後ほどControllerの章で詳しく説明します
- templates/index.html
    - View。htmlやText::Xslateなどを使って書く。
    - 後ほどViewの章で詳しく説明します


### テストサーバの起動
```Bash
$ perl script/appup
Watching lib script/lib script/app.psgi for file updates.
HTTP::Server::PSGI: Accepting connections at http://0:3000/
# http://localhost:3000/ でアクセスできる
```


## 4.3 ブックマーク一覧を作ってみよう

### 4.3.1 URI設計

実装に入る前にまずはURIを設計します。

### Bookmarkアプリでの要件
Bookmarkアプリでの機能は以下のとおり。
- 一覧 (list)
- 表示
- 作成 (add)
- 削除 (del)

これらに対応するURIは以下のように設計できる。

| パス | 動作 |
|------|------|
| / | ブックマーク一覧 |
| /bookmark?url=url | ブックマークの permalink |
| /bookmark/add?url=url&comment=comment (POST) | ブックマークの追加 |
| /bookmark/delete?url=url (POST) | ブックマークの削除 |


### 4.3.2 Controllerを書こう
以下のURI設計におけるブックマーク一覧(/)を例として、Controllerを作っていきます。

| パス | 動作 |
|------|------|
| / | ブックマーク一覧 |
| /bookmark?url=url | ブックマークの permalink |
| /bookmark/add?url=url&comment=comment (POST) | ブックマークの追加 |
| /bookmark/delete?url=url (POST) | ブックマークの削除 |


#### まずはHello Worldから
まずはURLとControllerの紐付けをする。lib/Intern/Bookmark/Config/Route.pmが紐付けの役割を担うので以下のように書く。これによって/にアクセスが来たら、Intern::Bookmark::Engine::Indexのdefaultメソッドに処理がいくようになる。
```Perl
sub make_router {
    return router {
        connect '/' => {
            engine => 'Index',
            action => 'default',
        };
    };
}
```

次にControllerの実装をする。先ほど指定したControllerに処理を書いていく。

```Perl
package Intern::Bookmark::Engine::Index;

sub default {
    my ($class, $c) = @_;

    $c->res->content_type('text/plain');
    $c->res->content('Welcome to the Hatena world!');
}

1;
```

- $class : Controllerのクラス (Intern::Bookmark::Engine::Index)
- $c : Contextオブジェクト (Intern::Bookmark::Context)
- $c->res->contentで出力を直接設定


#### ブックマーク一覧のControllerを作る
- bookmark.plのlist_bookmarks()に対応
- Controllerがやるべきこと
    - ユーザのブックマーク一覧を取得
    - 取得したブックマーク一覧を出力(Viewに渡す)

```Perl
# lib/Intern/Bookmark/Engine/Index.pm

sub default {
    my ($class, $c) = @_;

    # とりあえずuserはskozawa決め打ち
    my $user = Intern::Bookmark::Service::User->find_user_by_name($c->db, {
        name => 'skozawa',
    });

    # ブックマーク一覧を取得
    my $bookmarks = Intern::Bookmark::Service::Bookmark->find_bookmarks_by_user(
        $c->db,
        { user => $user },
    );
    Intern::Bookmark::Service::Bookmark->load_entry_info($c->db, $bookmarks);

    # Viewを指定し、ブックマーク一覧をViewに渡す
    $c->html('index.html', {
        bookmarks => $bookmarks,
    });
}
```

- ユーザのブックマーク一覧の取得(モデルへのアクセス)は同じ
- ビュー指定とデータの受け渡し
    - $c->htmlでviewのファイルの指定と、データの受け渡しができる


#### Controllerのロジックを分離する
- いろんなページで使うロジックはモデルに分離しておくべき
    - 上のコードだったらuserの取得はいろんなページで使うだろう
- userの取得を$cのメソッドとして定義してみる

```Perl
# lib/Intern/Bookmark/Context.pm
sub user {
    my ($self) = @_;
    my $user = Intern::Bookmark::Service::User->find_user_by_name($self->db, {
        name => 'skozawa',
    });
}
```

先ほどのIndex.pmは以下のようにできる。
```Perl
# lib/Intern/Bookmark/Engine/Index.pm

sub default {
    my ($class, $c) = @_;

    my $bookmarks = Intern::Bookmark::Service::Bookmark->find_bookmarks_by_user(
        $c->db,
        { user => $c->user },
    );
    Intern::Bookmark::Service::Bookmark->load_entry_info($c->db, $bookmarks);
    $c->html('index.html', {
        bookmarks => $bookmarks,
    });
}
```

- Controllerにはロジックを書かないくらいの気持ちでいると、綺麗にかける(かも)
- あんまりやりすぎても良くないのでバランスを取って



### 4.3.3 Viewを書こう
- Controllerでindex.htmlを指定しているので、templates/index.htmlが使われる
    - このファイルにhtmlとText::Xslate(TTerse + Text::Xslate::Bridge::TT2)で書く


### Text::Xslate(TTerse) 入門
- Text::Xslate
    - テンプレートエンジン
- Perlのテンプレートエンジンは他にも沢山
    - HTML::Template、Template::Toolkitなど

変数呼び出し
- Controllerで渡した変数が使える
```HTML
[% foo.bar %]
```

繰り返し処理
- 配列に対する繰り返し
```HTML
[% FOREACH item IN items %] ... [% END %]
```

分岐処理
```HTML
[% IF x %] ... [% ELSE %] ... [% END %]
```

URIエスケープ
```HTML
<a href="http://b.hatena.ne.jp/search/tag?q=[% uri_escape(word) %]">
```

外部テンプレートからの読み込み
```HTML
[% INCLUDE "header.html" %]
```

マクロ
```HTML
[% MACRO show_title(title) BLOCK %]
<h1>[% title %]</h1>
[% END %]
```

参考
- TTerseの文法 : https://metacpan.org/module/Text::Xslate::Syntax::TTerse
- Bridge::TT2で追加される機能
    - https://metacpan.org/module/Text::Xslate::Bridge::TT2
    - ここのvmethodsが増える : https://metacpan.org/module/Template::Manual::VMethods


#### ブックマーク一覧のViewを作る
- Controllerで指定したViewはtemplates/index.htmlでしたね
- そこに追加して行きましょう

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

- Controllerから渡したbookmarksにアクセスできている
- Xslateは自動でhtmlをエスケープしてくれている
    - 逆にエスケープをオフにする時はXSSに注意


### 4.3.4 テストを書こう
ここまでで機能は出来上がりましたが、作った機能にはテストを書きましょう。ここではHello Worldページの簡単なテストだけ書きます。詳しくはお手本コードを参照して、テストを書くようにしてください。

```Perl
package t::Intern::Bookmark::Engine::Index;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use parent qw(Test::Class);

use Test::Intern::Bookmark;
use Test::Intern::Bookmark::Mechanize;
use Test::Intern::Bookmark::Factory;

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

- Test::WWW::Mechanize
    - Webアプリのテストによく利用されるモジュール
    - WWW::Mechanize のテスト用クラス
    - PSGIなWebアプリの場合は Test::WWW::Mechanize::PSGI が利用できる
    - 詳しくは t/Test/Intern/Bookmark/Mechanize.pm

- 参考情報
    - https://metacpan.org/module/WWW::Mechanize
    - https://metacpan.org/module/Test::WWW::Mechanize
    - https://metacpan.org/module/Test::WWW::Mechanize::PSGI


## 一旦おさらい

- Hatena::Newbieでの開発の流れは
  1. URIを決める
  2. URIとControllerの紐付けを定義する
  3. 紐付けたControllerを書いて、Viewにデータを渡す
  4. 渡されたデータを使って、対応するViewを書く(html、Text::Xslateなど)


## 4.4 他の機能も作ってみよう

今度はbookmark追加を作ってみましょう。要件は以下のようにしてみます。
- GET /bookmark/add -> bookmark追加のフォーム
- POST /bookmark/add -> bookmark追加 + redirect

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

- { method => '...' }とすることでHTTP Methodを制限することが可能

### Controllerを作る
- 指定したControllerは
    - フォーム : Intern::Bookmark::Engine::Bookmarkのadd_get
    - 作成 : Intern::Bookmark::Engine::Bookmarkのadd_post

```Perl
sub add_get {
    my ($class, $c) = @_;

    my $url = $c->req->parameters->{url};

    my ($bookmark, $entry);
    if ($url) {
        # 編集時はurlが存在
        $entry = Intern::Bookmark::Service::Entry->find_entry_by_url($c->db, {
            url => $url,
        });
        $bookmark = Intern::Bookmark::Service::Bookmark->find_bookmark_by_user_and_entry($c->db, {
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

    Intern::Bookmark::Service::Bookmark->add_bookmark($c->db, {
        user    => $c->user,
        url     => $url,
        comment => $comment,
    });

    $c->res->redirect('/');
}

```

- parameterを取得したい時は$c->req->parameters->{url}みたいに
    - GET /bookmark?url=...とか、POSTのbody parameter(formのinputのやつとか)とかをとれる

- redirectは$c->res->redirect


### Hatena::NewbieのRequest API、Response API
Requestを処理するオブジェクトやResponseを処理するオブジェクトは$cから取得できます。

- $c->req : Intern::Bookmark::Requestオブジェクト
    - $c->req->param : GETやPOSTで渡ってくるparameter(query, body)
    - $c->req->uri : リクエストURIオブジェクト
    - $c->req->header : リクエストヘッダ
- $c->res : Plack::Responseオブジェクト
    - $c->html : Viewの指定
    - $c->res->content_type : content typeの指定
    - $c->res->content : contentの指定(Viewを作らず直接文字を返したい場合)
    - $c->res->redirect : 特定のURIもしくはpathにリダイレクト
などなど

詳しくは以下を読みましょう
- https://metacpan.org/module/Plack::Request
- https://metacpan.org/module/Plack::Response

### Viewを書く
- GET /bookmark/add にはテンプレートが必要
- Controllerで指定したテンプレートはtemplates/bookmark/add.html

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

- /bookmark/addにPostするform
    - inputで指定されている、url, commentをparameterとしてPOST


他の機能はこれまで説明した機能を用いて実装できるので、Intern-Bookmarkを見てください！


## 4.5 URIを変更してみよう
URIとControllerの紐付けにはRouter::Simpleを用いています。そのためいろいろなURIを使うことが出来ます。

例
```Perl
connect '/bookmark/{id}', { engine => 'Bookmark', action => 'default' }
# /bookmark/1234 とかでアクセス可能
# $c->req->route_parameters->{id}とかで取れる
```

以下の書籍などを参考にして、URIの設計をしてみましょう。

参考書籍
- Webを支える技術 5章


## この章のまとめ
- Hatena::Newbieによる開発の流れは
     - URIを決める
     - URIとControllerを紐付ける
     - それに対応するControllerを書いて、Viewにデータを渡す
     - 渡されたデータを使って、対応するViewを書く
- フレームワークを用いれば面倒な部分を気にせずにWebアプリが書ける
     - またフレームワーク自体もモジュールの組み合わせでシンプルに実装できる
- ビジネスロジックはできるだけModelに入れてControllerに書かないくらいの気持ちでいたほうがいい(かも)



# 5. Webアプリケーションにおけるセキュリティの基本
この章ではWebアプリケーションにおけるセキュリティの基本について話します。

## なぜセキュリティ?
- Webアプリを作るときはセキュリティを意識することが必須
- 脆弱性を作ると
    - ユーザがプライベートと思っているものに他者からアクセスされてしまう
    - 特定ユーザしか編集できない情報を他者から勝手に編集されてしまう
    - など問題が多い


## 今回話すこと
- 攻撃方法は様々
- 今回は２つを簡単に話します
    - XSS
    - 不正データの挿入
- さらに詳しくは「体系的に学ぶ 安全なWebアプリケーションの作り方　脆弱性が生まれる原理と対策の実践」を


## XSS
- XSSとはクロスサイトスクリプティング(Cross Site Scripting)の略
- ユーザの送ってきたスクリプトをページ内に埋め込まれて実行される脆弱性
- 様々な問題
    - 特定のユーザのログイン情報を抜き取る
    - サイトのページを改ざんされる

例えば今回のBookmarkアプリの一覧表示(/)で、ブックマークのコメントをユーザ入力のまま表示させてしまったとします
```HTML
# Xslateではrawというフィルタに通すとhtmlエスケープされなくなる
<p>[% bookmark.comment | raw %]</p>
```

この場合以下のコメントに以下の文字が入っていると、jsが実行されてしまう
```
<script>alert('XSS')</script>
```

- 根本的な対策
    - 出力時に適切なエスケープをすること
    - 今回の場合は、Xslateが自動的にエスケープしてくれるので何もしなくて良い
    - ただし、明示的にrawでエスケープしなくした場合は注意が必要

## 不正データの挿入
- 「ユーザが入力した不正なデータをそのままアプリケーションで利用してしまう」こと
- 例えばブックマーク追加時(/bookmark.add)において、URLでない文字をURLとして追加してしまう
- 対策は「ユーザ入力を適切にバリデーションする」こと
    - perlでフォームのバリデートをするにはFormValidator::Simpleなど

```Perl
sub add_post {
    my ($self, $c) = @_;

    my $result = FormValidator::Simple->check($c->req => [
        url => ['NOT_BLANK', 'HTTP_URL'],
    ]);

    unless ($result->has_error) {
        # ブックマーク追加処理
    }

    $r->res->redirect('/');
}
```



# おまけ1. PSGI/Plack
 
## WebサーバとWebアプリケーションが共通のインターフェースを利用する

- サーバリクエスト、サーバレスポンスはサーバのインターフェイスに依存していたが、最近はサーバとアプリケーションがPSGIという仕様に従うように

<img src="http://cdn-ak.f.st-hatena.com/images/fotolife/s/shiba_yu36/20120712/20120712135246.png" />

- WAFの「サーバとの対話を仲介、抽象化する」という機能はPlackに実装
- サーバとアプリのインターフェースが決まり、組み換えが簡単に
    - これまではサーバごとにWAFが対応

<img src="http://cdn-ak.f.st-hatena.com/images/fotolife/s/shiba_yu36/20120712/20120712135247.png" />


## PSGI概要
- WebサーバとWebアプリケーションの間の、サーバリクエストレスポンスの<strong>共通インターフェース仕様</strong>
- これによりPSGIに対応したWebサーバとWebアプリケーションを簡単に組み替えられるようになった
    - PSGIを喋るサーバ -> Starman, HTTP::Server::PSGI, Corona, Twiggyなど
    - PSGIを喋るWAF -> Amon2, Mojolicious, Catalyst, Jiftyなど
    - サーバにApache以外の選択肢が増えると嬉しい
 
### PSGIの簡単な仕様
- アプリケーション側は以下の仕様を満たすコードリファレンス(ハンドラ)
    1. 環境変数をハッシュ($env)として受け取り
    2. レスポンスをPSGIに定められた形式の配列リファレンスで返す
 


## PSGI概要
- サーバ構成の部分でも少し話をした
- WebサーバとWebアプリケーションの間の、サーバリクエストレスポンスの<strong>共通インターフェース仕様</strong>
- これによりPSGIに対応したWebサーバとWebアプリケーションを簡単に組み替えられるようになった
    - PSGIを喋るサーバ -> Starman, HTTP::Server::PSGI, Corona, Twiggyなど
    - PSGIを喋るWAF -> Catalyst, Jifty, Mojolicious, Amon2など
    - サーバにApache以外の選択肢が増えると嬉しい


## PSGIの簡単な仕様
- アプリケーション側は以下の仕様を満たすコードリファレンス(ハンドラ)
    1. 環境変数をハッシュ($env)として受け取り
    1. レスポンスをPSGIに定められた形式の配列リファレンスで返す

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
    - Plack::Request : リクエスト操作
        - $envからqueryを取り出すなど
    - Plack::Response : レスポンス操作
        - codeやcontentを指定して、response用配列リファレンスを作るなど
- PSGIの実装としてPlackがあることによって、簡単に$envやresponseを扱える
- その他開発に便利なツールも(plackupなど)
- 面倒なリクエストレスポンス処理などはPlackがやってくれるので、<strong>WAFも簡単に作れる</strong>

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

- 仕様が単純なため、アプリケーションの前後にhookを仕込むのも容易
```Perl
# 先ほどの$appにhookを仕込む
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

- Plack::Middleware::*
- 後ほど出てくるはてなOAuth認証の例もPlack::Middlewareの仕組みを使っていたりします
- 同じような仕組みを使ってアクセスログを残したり、実行時間を記録したり、いろいろできる


## まとめ
- PSGIというサーバとアプリの共通インターフェースがあることによって、簡単に組み合わせを変えることができる
    - リクエストをhashref、レスポンスをarrayrefとして表現する
- PlackというPSGIのアプリ側実装があることによって簡単にWAFのようなものを作ることができる
- 仕様が簡単なのでアプリケーションの前後にhookを仕込むことも可能
    - Plack::Middleware





# おまけ2 : Plack、Router::Simple、Text::Xslateを利用した簡易WAF
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

- Plack、Router::Simple、Text::Xslateなど、WAFのパーツは存在
- 100行くらいのコードで簡単に実装可能

```Perl
package WAF;
use strict;
use warnings;

use Exporter::Lite;
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
        }
        else {
            [404, [], ['not found']];
        }
    };
}

# ------ Controllerで利用するAPI ------

package WAF::Context;

use Data::Section::Simple qw(get_data_section);

sub new {
    my ($class, %args) = @_;
    return bless {
        env          => $args{env},
        data_section => $args{data_section},
    }, $class;
}

sub env {
    my $self = shift;
    return $self->{env};
}

sub data_section {
    my $self = shift;
    return $self->{data_section};
}

sub req {
    my $self = shift;
    return $self->{_req} ||= WAF::Request->new($self->env);
}

sub res {
    my $self = shift;
    return $self->{_res} ||= $self->req->new_response(200);
}

sub render {
    my ($self, $tmpl_name, $args) = @_;
    my $str  = $self->data_section->get_data_section($tmpl_name);
    my $body = WAF::View->render_string($str, $args);
    return $self->res->body($body);
}

package WAF::Request;

use parent qw(Plack::Request);

package WAF::Response;

use parent qw(Plack::Response);



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



# 課題内容
- Hatena::Newbie を利用して、前回作った diary.pl を Web アプリケーションにして下さい

### 課題1
ブラウザですでに書かれたdiaryの記事を読めるように

- ブラウザで読めるように
    - テンプレートをちゃんと使って
    - 設計を意識しよう
    - 良いURI設計をしてみよう
- ページャを実装
    - OFFSET / LIMIT と ?page=? というクエリパラメータを使います
    - <strong>明日課題に繋がるので必須です</strong>

### 課題2

- ブラウザで書けるように
- ブラウザで更新できるように
- ブラウザで削除できるように

### 課題3 (オプション)

以下の様な追加機能をできる限り実装してみてください。

例)
- 認証 (Hatena/Twitter OAuth)
- フィードを吐く (Atom, RSS)
- デザイン
- 管理画面
- いろいろ貼り付け機能
- その他自分で思いついたものがあれば

### 注意
- WAF自体のコードはproject内に入っています
    - いろんなCPANモジュールを使ってますがそれぞれ
        - perldoc Module名でドキュメントが見れる
        - perldoc -m Module名でコードが見れる
- なのでハマったらどういうふうにWAFを作ってるか調べてみるのも良いです
- 全然分からなかったらすぐに人に聞きましょう

## 参考 : Hatena::Newbieのclassの役割
```Bash
Intern-Diary-2013/
├── README.md
├── cpanfile
├── db # DB設定ファイル
│   └── schema.sql
├── lib # Perlモジュール
│   └── Intern
│       ├── Diary
│       │   ├── Config
│       │   │   └── Route.pm # ルーティングのルールを書くクラス
│       │   ├── Config.pm # 環境変数によって設定を切り替えるためのクラス。Config::ENV
│       │   ├── Context.pm # アプリケーションのいろいろな場所で使えるクラス
│       │   ├── DBI # DBアクセス周りをやってくれる
│       │   │   └── Factory.pm
│       │   ├── DBI.pm
│       │   ├── Engine # Controller置き場
│       │   │   └── Index.pm
│       │   ├── Error.pm # ディスパッチやController処理のエラーを扱うクラス
│       │   ├── Logger.pm
│       │   ├── Request.pm # リクエストを扱うクラス。Plack::Requestの子クラス
│       │   ├── Util.pm
│       │   └── View
│       │       └── Xslate.pm # Viewのクラス。Xslateのオプションを決めている
│       └── Diary.pm # フレームワークの中核。ディスパッチやエラーハンドリングなど
├── script # 様々なscriptファイル
│   ├── app.psgi
│   ├── appup # ローカル開発用スクリプト
│   └── setup.sh # セットアップ用スクリプト
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
│       └── dbi.t
└── templates # テンプレート(View)置き場
    ├── _wrapper.tt
    └── index.html
```

## 参考：ユーザ認証層
```Perl
package Plack::Middleware::HatenaOAuth;
use strict;
use warnings;

our $VERSION   = '0.01';

use parent 'Plack::Middleware';
use Plack::Util::Accessor qw( consumer_key consumer_secret consumer login_path );
use Plack::Request;
use Plack::Session;

use OAuth::Lite::Consumer;
use JSON::XS;

sub prepare_app {
    my ($self) = @_;
    die 'require consumer_key and consumer_secret'
        unless $self->consumer_key and $self->consumer_secret;

    $self->consumer(OAuth::Lite::Consumer->new(
        consumer_key       => $self->consumer_key,
        consumer_secret    => $self->consumer_secret,
        site               => q{https://www.hatena.com},
        request_token_path => q{/oauth/initiate},
        access_token_path  => q{/oauth/token},
        authorize_path     => q{https://www.hatena.ne.jp/oauth/authorize},
        ($self->{ua} ? (ua => $self->{ua}) : ()),
    ));
}

sub call {
    my ($self, $env) = @_;
    my $session = Plack::Session->new($env);

    my $handlers = {
        $self->login_path => sub {
            my $req = Plack::Request->new($env);
            my $res = $req->new_response(200);
            my $consumer = $self->consumer;
            my $verifier = $req->parameters->{oauth_verifier};

            if ( $verifier ) {
                my $access_token = $consumer->get_access_token(
                    token    => $session->get('hatenaoauth_request_token'),
                    verifier => $verifier,
                ) or die $consumer->errstr;
                $session->remove('hatenaoauth_request_token');

                {
                    my $res = $consumer->request(
                        method => 'POST',
                        url    => qq{http://n.hatena.com/applications/my.json},
                        token  => $access_token,
                    );
                    $res->is_success or die;
                    $session->set('hatenaoauth_user_info', decode_json($res->decoded_content || $res->content));
                }
                $res->redirect( $session->get('hatenaoauth_location') || '/' );
                $session->remove('hatenaoauth_location');
            } else {
                my $request_token = $self->consumer->get_request_token(
                    callback_url => [ split /\?/, $req->uri, 2]->[0],
                    scope        => 'read_public',
                ) or die $consumer->errstr;

                $session->set(hatenaoauth_request_token => $request_token);
                $session->set(hatenaoauth_location => $req->parameters->{location});
                $res->redirect($consumer->url_to_authorize(token => $request_token));
            }
            return $res->finalize;
        },
    };

    $env->{'hatena.user'} = ($session->get('hatenaoauth_user_info') || {})->{url_name};
    return ($handlers->{$env->{PATH_INFO}} || $self->app)->($env);
}

1;

__END__

=head1 SYNOPSIS

  use Plack::Builder;

  my $app = sub {
      my $env = shift;
      my $session = $env->{'psgix.session'};
      return [
          200,
          [ 'Content-Type' => 'text/html' ],
          [
              "<html><head><title>Hello</title><body>",
              $env->{'hatena.user'}
                  ? ('Hello, id:' , $env->{'hatena.user'}, ' !')
                  : "<a href='/login?location=/'>Login</a>"
          ],
      ];
  };

  builder {
      enable 'Session';
      enable 'Plack::Middleware::HatenaOAuth',
           consumer_key       => 'vUarxVrr0NHiTg==',
           consumer_secret    => 'RqbbFaPN2ubYqL/+0F5gKUe7dHc=',
           login_path         => '/login',
           # ua                 => LWP::UserAgent->new(...);
      $app;
  };

=cut
```

## 参考資料
- https://metacpan.org/module/Router::Simple
- https://metacpan.org/module/Plack
- https://metacpan.org/module/Text::Xslate





<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/2.1/jp/"><img alt="クリエイティブ・コモンズ・ライセンス" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/2.1/jp/88x31.png" /></a><br />この 作品 は <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/2.1/jp/">クリエイティブ・コモンズ 表示 - 非営利 - 継承 2.1 日本 ライセンスの下に提供されています。</a>