# Perl によるデータベースプログラミング

## Perl から RDBMS を使う: DBI

* Perl からデータベース管理システムに接続する最も基本的なモジュール
* [DBI](http://search.cpan.org/~timb/DBI/DBI.pm)
  * DriverですべてのRDBMSの差を吸収して統一的なインターフェイスを提供する
  * (DBD::*) MySQL、PostgreSQL、SQLite、…

## DBI を用いる

* PerlでRDBMSとやり取りする最も素朴な方法
  * プレースホルダ機能
  * プリペアードステートメント機能

``` perl
use DBI;

my $dbh = DBI->connect('dbi:mysql:dbname=vocaloid', 'root', '')
    or die $DBI::errstr;
my $sth = $dbh->prepare(q[
    SELECT * FROM artist
    WHERE birthday < ?
    ORDER BY birthday ASC
]);
$sth->execute('2008-01-01');
my $artists = $dbh->fetchall_arrayref(+{});

# => [
#      {
#        'id' => '1',
#        'name' => '初音ミク',
#        'birthday' => '2007-08-31'
#      },
#      {
#        'id' => '2',
#        'name' => '鏡音リン',
#        'birthday' => '2007-12-27'
#      },
#      {
#        'id' => '3',
#        'name' => '鏡音レン',
#        'birthday' => '2007-12-27'
#      }
#    ]
```

* インターフェースがちょっとむずい

## より便利なモジュール

以下のようなモジュールを使います

* [DBIx::Sunny](http://search.cpan.org/~kazeburo/DBIx-Sunny/lib/DBIx/Sunny.pm)
  * DBIを少し拡張し、よりわかりやすいインターフェイスを提供する
* [SQL::NamedPlaceholder](http://search.cpan.org/~satoh/SQL-NamedPlaceholder/lib/SQL/NamedPlaceholder.pm)
  * プレースホルダに名前をつけることができる

```perl
my $dbh = DBI->connect($dsn, $user, $password, {
    RootClass => 'DBIx::Sunny',
});

my ($sql, $bind) = SQL::NamedPlaceholder::bind_named(q[
    SELECT * FROM artist
    WHERE name = :name
    LIMIT 1
], {
    name => '初音ミク',
});

my $rows = $dbh->select_all($sql, @$bind);
```

## Q:PerlにはActiveRecordっぽいものはないの???

* A: あるけどつかってない
  * ORMはSQLを抽象化し、どんなSQLが、どこでいくつ発行されるかがわかりにくい。
  * 思っても見ないところで大量のSQLを発行してしまい、パフォーマンスを劣化させた経験から
  * 「コストがかかることを抽象化して簡単にしてはならない」


## 得られたデータをオブジェクトに変換する

* 対応するレコードを表すオブジェクト( = Model)に変換すると便利
  * 得られたハッシュはそのままでは区別がない
* 例:
  * artistテーブルに対応するArticstクラス
  * albumテーブルに対応するAlbumクラス

```perl
my $rows = $dbh->select_all($sql, @$bind);
$rows = [ map { Vocaloid::Model::Artist->new($_) } @$rows ];
```

``` perl
package Vocaloid::Model::Artist;

use strict;
use warnings;
use utf8;

use Encode;
use DateTime::Format::MySQL;

use Class::Accessor::Lite (
    ro => [qw(id)],
    new => 1,
);

sub name {
    my ($self) = @_;
    decode_utf8 $self->{name} || '';
}

sub birthday {
    my ($self) = @_;
    $self->{_birthday} ||= eval {
        my $dt = DateTime::Format::MySQL->parse_datetime( $self->{birthday} );
        $dt->set_time_zone('UTC');
        $dt->set_formatter( DateTime::Format::MySQL->new );
        $dt;
    };
}

1;
```

## DBIx::Sunny によるSQL発行

* ここから説明する方法を使ってクエリを発行しよう

## 条件に合う一行を取得 `select_row`

``` perl
my $artist = $dbh->select_row(q[
    SELECT * FROM artist
    WHERE name = ?
    LIMIT 1
], '初音ミク');
$artist = Vocaloid::Model::Artist->new($artist);

print $artist->id, "\\n";
print $artist->name, "\\n";
print $artist->birthday, "\\n";
```

``` sql
SELECT * FROM artist WHERE name = '初音ミク' LIMIT 1;
```

<table>
  <tr><th>id</th><th>name</th><th>birthday</th></tr>
  <tr><td>1</td><td>初音ミク</td><td>2007-08-31</td></tr>
</table>

## 条件に合う行を複数取得 `select_all`

``` perl
my $artists = $dbh->select_all(q[
    SELECT * FROM artist
      WHERE
        name LIKE ?
      ORDER BY id ASC
      LIMIT ?
      OFFSET ?
], '鏡音%', 10, 0);

for (@$artists) {
    my $artist = Vocaloid::Model::Artist->new($artist);
    print $artist->name, "\\n";
}
```

``` sql
SELECT * FROM artist WHERE name LIKE '鏡音%' ORDER BY id ASC LIMIT 10 OFFSET 0;
```

<table>
  <tr><th>id</th><th>name</th><th>birthday</th></tr>
  <tr><td>2</td><td>鏡音リン</td><td>2007-12-27</td></tr>
  <tr><td>3</td><td>鏡音レン</td><td>2007-12-27</td></tr>
</table>

## 行の挿入 `query`

``` perl
$dbh->query(q[
    INSERT INTO artist
      SET
        id       = ?,
        name     = ?,
        birthday = ?
], 5, '重音テト', '2008-04-02');
```


``` sql
INSERT INTO artist (id, name, birthday)
    VALUES (5, '重音テト', '2008-04-01');
```

<table>
  <tr><th>id</th><th>name</th><th>birthday</th></tr>
  <tr><td>1</td><td>初音ミク</td><td>2007-08-31</td></tr>
  <tr><td>2</td><td>鏡音リン</td><td>2007-12-27</td></tr>
  <tr><td>3</td><td>鏡音レン</td><td>2007-12-27</td></tr>
  <tr><td>4</td><td>巡音ルカ</td><td>2009-01-30</td></tr>
  <tr><td>5</td><td>重音テト</td><td>2008-04-01</td></tr>
</table>

## 行の更新

``` perl
$dbh->query(q[
    UPDATE artist
      SET
        name = ?
      WHERE
        id = ?
]), '弱音ハク', 1);
```


``` sql
UPDATE artist SET name = '弱音ハク' WHERE id = 1;
```

<table>
  <tr><th>id</th><th>name</th><th>birthday</th></tr>
  <tr><td>1</td><td><del>初音ミク</del>弱音ハク</td><td>2007-08-31</td></tr>
  <tr><td>2</td><td>鏡音リン</td><td>2007-12-27</td></tr>
  <tr><td>3</td><td>鏡音レン</td><td>2007-12-27</td></tr>
  <tr><td>4</td><td>巡音ルカ</td><td>2009-01-30</td></tr>
  <tr><td>5</td><td>重音テト</td><td>2008-04-01</td></tr>
</table>

## 行の削除

``` perl
$dbh->query(q[
    DELETE FROM artist
      WHERE
        id = ?
], 1);
```

``` sql
DELETE FROM artist WHERE id = 1;
```
<table>
  <tr><th>id</th><th>name</th><th>birthday</th></tr>
  <tr><td>2</td><td>鏡音リン</td><td>2007-12-27</td></tr>
  <tr><td>3</td><td>鏡音レン</td><td>2007-12-27</td></tr>
  <tr><td>4</td><td>巡音ルカ</td><td>2009-01-30</td></tr>
</table>

## セキュリティ

* データベースの脆弱性は致命的
* データの漏洩、損失
* 気をつけましょう

## 悪い例

``` perl
my $name = "..."; # ユーザの入力

my $artists = $dbh->select_all_as(
    "SELECT * FROM artist WHERE name = $name",
    +{}, 'Vocaloid::Model::Artist'
);
```

``` sql
SELECT * FROM artist WHERE name = '初音ミク';
```

## 気をつけるべきこと

* **ユーザの入力は安全ではない！**
* 名前に "`''; DROP TABLE artist`" と入力されると…？
* ref. [SQLインジェクション脆弱性](http://ja.wikipedia.org/wiki/SQL%E3%82%A4%E3%83%B3%E3%82%B8%E3%82%A7%E3%82%AF%E3%82%B7%E3%83%A7%E3%83%B3)
* 対策として、必ずプレースホルダを使うこと

``` sql
SELECT * FROM artist WHERE name = ''; DROP TABLE artist;
```

## 実践編: bookmark.pl

* 実践編です
* 小さなブックマークアプリを書いていく過程を見ていきます

## 大まかな機能

* ユーザは URL (エントリ) を個人のブックマークに追加し、コメントを残せる
* エントリはユーザに共通の情報を持つ (ページタイトルなど)
* とりあえず一人用で (マルチユーザも視野にいれつつ)

## add, list, delete

* bookmark.pl &lt;<var>user_name</var>&gt; add &lt;<var>url</var>&gt; [コメント]
  * ブックマークを追加


``` text
$ ./bookmark.pl motemen add http://www.yahoo.co.jp/ ヤッホー
Bookmarked [8] Yahoo! JAPAN <http://www.yahoo.co.jp/>
    @2011-08-16 ヤッホー
```

* bookmark.pl &lt;<var>user_name</var>&gt; list
  * ブックマークの一覧を出力


``` text
$ ./bookmark.pl motemen list
 *** motemen's bookmarks ***
[8] Yahoo! JAPAN <http://www.yahoo.co.jp/>
    @2011-08-16 ヤッホー
[7] The CPAN Search Site - search.cpan.org <http://search.cpan.org/>
    @2011-08-16 くぱん
[6] はてな <http://www.hatena.ne.jp/>
    @2011-08-16 はてー
[4] Google <http://www.google.com/>
    @2011-08-16 ごー
[1] motemen <http://motemen.appspot.com/>
    @2011-08-15 モテメンドットコム
```

* bookmark.pl &lt;<var>user_name</var>&gt; delete &lt;<var>url</var>&gt;
  * ブックマークを削除


``` text
$ ./bookmark.pl motemen delete http://www.google.com/
Deleted
```

## では作ってみましょう

コードを手元にもってきて試してみましょう

``` text
$ git clone git@github.com:hatena/perl-Intern-Bookmark.git
$ cd perl-Intern-Bookmark
$ script/setup_db.sh
```

## データのモデリング
* データベーススキーマを考える前にどのようなデータが登場するか整理してみよう。
 * 言語基礎の講義ではメモリ上でデータを使うためのモデリングだった
 * この講義ではデータベースとの連携をふまえて1から考える

## 登場する概念(モデル)

* `User` ブックマークをするユーザ
* `Entry` ブックマークされた記事(URL)
* `Bookmark` ユーザが行ったブックマーク

###  概念動詞の関係(クラス図)

<div style="text-align: center; background: #fff"><img src="http://f.st-hatena.com/images/fotolife/h/hakobe932/20140725/20140725163235.png"></div>

- 1つのEntryには複数のBookmarkが属する (一対多)
- 1つのUserには複数のBookmarkが属する (一対多)

はじめに図を書くと整理できる & モデリングをレビューしてもらえる。

## スキーマの設計
クラス図で分析したデータ構造をSQLのテーブルに対応付ける。

- モデル同士の関係
- 何によってデータを一意に特定できるか

### user

<table>
  <tr><th>id</th><th>name</th></tr>
  <tr><td>1</td><td>antipop</td></tr>
  <tr><td>2</td><td>motemen</td></tr>
  <tr><td>3</td><td>cho45</td></tr>
</table>

* UNIQUE KEY (name)

### entry

ユーザに共通の、URL に関する情報

<table>
  <tr><th>id</th><th>url</th><th>title</th></tr>
  <tr><td>1</td><td>http://www.example.com/</td><td>IANA — Example domains</td></tr>
  <tr><td>2</td><td>http://www.hatena.ne.jp/</td><td>はてな</td></tr>
  <tr><td>3</td><td>http://motemen.appspot.com/</td><td>motemen</td></tr>
</table>

*  UNIQUE KEY (url)

### bookmark

ユーザが URL をブックマークした情報 (ユーザ×エントリ)
<table>
  <tr><th>id</th><th>user_id</th><th>entry_id</th><th>comment</th></tr>
  <tr><td>1</td><td>1 (= antipop)</td><td>1 (= example.com)</td><td>例示用ドメインか〜。</td></tr>
  <tr><td>2</td><td>1</td><td>2 (= はてな)</td><td>はてな〜。</td></tr>
  <tr><td>3</td><td>2 (= motemen)</td><td>3 (= motemen.com)</td><td>僕のホームページです</td></tr>
  <tr><td>4</td><td>3 (= cho45)</td><td>3</td><td>モテメンさんのホームページですね</td></tr>
  <tr><td>5</td><td>3</td><td>1</td><td>example ですね</td></tr>
</table>

*  UNIQUE KEY (user_id, entry_id)

## プログラムの設計

* データの定義はできた
* どこにどのようなプログラムを書けばよいか??
  * DBにアクセス
  * 得られたデータを集めてくる
  * データを表示する部分
* 綺麗に分割することで品質の高いソフトウェアになる

## レイヤ化アーキテクチャ

* プログラムを責務ごとのレイヤに分けて設計する。
* より上位の層が下位の層を利用するという形でプログラムを実装することで、見通しがよくなる

| 名前 | 説明 |
| ---- | ---- |
| インターフェース層 | ユーザや外部プログラムとインタラクションする層 |
| アプリケーション層 | ドメイン層の機能を同士を組み合わせる層  |
| ドメイン層 | インフラ層の機能を使いプログラムの役立つ機能を実装する層 |
| インフラ層 | DBやネットワークなどプログラムの外部機能とやりとりする層 |

## ServiceとModel
はてなでよく使われている、ドメイン層を整理するための設計方法の一つ。

* Service: データベースなどのインフラ層とのやり取りを実装するモジュール
* Model: モデルを抽象化した単純なオブジェクト

Modelを単純なオブジェクトにすることで、ドメイン層以上から
インフラ層への依存が起こらないようにしている。

## bookmark.plの構造

* **bookmark.pl は最小限の処理に**
  * ドメインロジックはドメイン層であるModelとServiceに集約
  * `add_bookmark` や `list_bookmarks`などのコマンドはModelとServiceを組み合わせるだけ = アプリケーション層
  * 引数からコマンドを受け付ける部分 = インターフェース層

```perl
#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

use Encode;
use Pod::Usage;

use FindBin;
use lib "$FindBin::Bin/../lib";

use DBIx::Sunny;

use Intern::Bookmark::Config;
use Intern::Bookmark::Service::User;
use Intern::Bookmark::Service::Bookmark;

BEGIN { $ENV{INTERN_BOOKMARK_ENV} = 'local' };

my %HANDLERS = (
    add    => \&add_bookmark,
    list   => \&list_bookmarks,
    delete => \&delete_bookmark,
);

my $name    = shift @ARGV;
my $command = shift @ARGV;
my $db      = do {
    my $config = config->param('db')->{intern_bookmark};
    DBIx::Sunny->connect(map { $config->{$_} } qw(dsn user password));
};

my $user = Intern::Bookmark::Service::User->find_user_by_name($db, +{ name => $name });
unless ($user) {
    $user = Intern::Bookmark::Service::User->create($db, +{ name => $name });
}

my $handler = $HANDLERS{ $command } or pod2usage;
$handler->($user, @ARGV);

exit 0;

sub add_bookmark {
    my ($user, $url, $comment) = @_;

    die 'url required' unless defined $url;

    my $bookmark = Intern::Bookmark::Service::Bookmark->add_bookmark($db, +{
        user    => $user,
        url     => $url,
        comment => decode_utf8 $comment,
    });

    print 'Bookmarked ' . $bookmark->{entry}->url . ' ' . $bookmark->comment . "\n";
}

sub list_bookmarks {
    my ($user) = @_;

    printf "--- %s's Bookmarks ---\n", $user->name;

    my $bookmarks = Intern::Bookmark::Service::Bookmark->find_bookmarks_by_user($db, +{
        user => $user,
    });
    $bookmarks = Intern::Bookmark::Service::Bookmark->load_entry_info($db, $bookmarks);

    foreach my $bookmark (@$bookmarks) {
        print $bookmark->{entry}->url . ' ' . $bookmark->comment . "\n";
    }
}

sub delete_bookmark {
    my ($user, $url) = @_;

    die 'url required' unless defined $url;

    my $bookmark = Intern::Bookmark::Service::Bookmark->delete_bookmark_by_url($db, +{
        user => $user,
        url  => $url,
    });

    print "Deleted \n";
}
```

## Modelの実装

* モデルを抽象化した単純なオブジェクト。
  * テーブルの1レコードがModelの1オブジェクト
* **ここからデータベースへアクセスしない** ように注意
  * 思っても見ないところからDBアクセスが行われないように

``` perl
package Intern::Bookmark::Model::User;

use strict;
use warnings;
use utf8;

use DateTime::Format::MySQL;

use Class::Accessor::Lite (
    ro => [qw(
        user_id
        name
    )],
    new => 1,
);

sub created {
    my ($self) = @_;
    $self->{_created} ||= eval {
        my $dt = DateTime::Format::MySQL->parse_datetime( $self->{created} );
        $dt->set_time_zone('UTC');
        $dt->set_formatter( DateTime::Format::MySQL->new );
        $dt;
    };
}

1;

```

* その他 Model::Entry, Model::Bookmark も同じように

## Serviceの実装
データベースなどのインフラ層とのやり取りを実装するモジュール。

* SQLを実行するのはServiceからのみ
* Serviceのメソッドは、必要に応じてModelのオブジェクトを返す


```perl
package Intern::Bookmark::Service::Bookmark;

sub add_bookmark {
    my ($class, $db, $args) = @_;

    my $user = $args->{user} // croak 'user required';
    my $url = $args->{url} // croak 'url required';
    my $comment = $args->{comment}// '';

    # Entry を探し、なければ作る
    my $entry = Intern::Bookmark::Service::Entry->find_or_create_entry_by_url($db, +{ url => $url });

    # すでにブックマークされているかもしれないから探す
    my $bookmark = $class->find_bookmark_by_user_and_entry($db, +{
        user  => $user,
        entry => $entry,
    });

    if ($bookmark) {
        # すでにブックマークされていたらアップデートする
        $class->update($db, +{
            bookmark_id => $bookmark->bookmark_id,
            comment     => $comment,
        });
    }
    else {
        # 始めてブックマークするから新しく Bookmark を作る
        $class->create($db, +{
            user_id  => $user->user_id,
            entry_id => $entry->entry_id,
            comment  => $comment,
        });
    }

    # ブックマークされたものを引いてくる
    $bookmark = $class->find_bookmark_by_user_and_entry($db, +{
        user  => $user,
        entry => $entry,
    });

    # Entry 情報と紐付ける
    $bookmark = $class->load_entry_info($db, [$bookmark])->[0];

    return $bookmark;
}
```

どんなSQLが使えるか考えてみよう。

``` perl
# ブックマーク一覧
# SELECT * FROM bookmark WHERE user_id = ... のようなSQLを使って実装
my $bookmarks = Intern::Bookmark::Service::Bookmark->find_bookmarks_by_user($db, +{
    user => $user,
});

# ブックマーク追加
# INSERT INTO bookmark ... のようなSQLを使って実装
Intern::Bookmark::Service::Bookmark->add_bookmark($db, +{
    user    => $user,
    url     => $url,
    comment => $comment,
});

# ブックマーク削除
# DELETE FROM bookmark WHERE id = ... のようなSQLを使って実装
Intern::Bookmark::Service::Bookmark->delete_bookmark_by_url($db, +{
    user => $user,
    url  => $url,
});
```

* いきなり実装を書くのは難しい？
  * 案1: とりあえずテストを書いてみる
  * 案2: とりあえず一番外側のスクリプトを書いてみる
* 試しながら少しずつ実装する
* croak
  * use [Carp](http://search.cpan.org/~zefram/Carp/lib/Carp.pm) すると使えます
  * die と似てるけど呼び出し元で死ぬ

## プログラムの設計のまとめ

* レイヤ化アーキテクチャを意識
* ServiceにはDBへのアクセスを書く
  * **ModelからDBにアクセスしない**
* Modelはテーブルのレコードを表現する
* bookmark.pl ではServiceのメソッドを呼び出し、Modelを表示する
* perl-Intern-Bookmarkをよく読もう

## テスト(again)

* 書いたプログラムが正しく動くことをどう確かめるか？
  * 小規模なら実際に動かしてみるのでもやっていける
    * = 大規模だとムリ
  * コードの変更の影響を完全に把握するのは無理
    * 意図せず別の機能に不具合を引き起こしていないか (リグレッション)
  * 他人のコードの意図は把握できない
    * 昔の自分も他人です (だいたい一晩から)
* 今回は単体テストを書きましょう

## テストすべきこと

* 正しい条件で正しく動くこと (正常系)
* おかしな条件で正しく動くこと (異常系)
  * エラーを吐くなど
* 境界条件で正しく動くこと

## テスト例

*  [Test::Class](http://search.cpan.org/~adie/Test-Class/lib/Test/Class.pm) という JUnit ライクなテストフレームワークを使っています

``` perl
package t::Intern::Bookmark::Service::Bookmark;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use Test::Intern::Bookmark;
use Intern::Bookmark::Context;
use String::Random qw(random_regex);

...

sub add_bookmark : Test(2) {
    my ($self) = @_;

    my $user = create_user;
    my $url = 'http://' . random_regex('\w{15}') . '.com/';

    my $db = Intern::Bookmark::Context->new->dbh;

    subtest 'bookmarkが作成される' => sub {
        my $bookmark = Intern::Bookmark::Service::Bookmark->add_bookmark($db, {
            user    => $user,
            url     => $url,
            comment => 'Comment',
        });

        ok $bookmark;
        is $bookmark->user_id, $user->user_id;
        is $bookmark->entry->url, $url;
        is $bookmark->comment, 'Comment';
    };

    subtest '同じurlをブックマークしたときcommentが更新される' => sub {
        my $bookmark = Intern::Bookmark::Service::Bookmark->add_bookmark($db, {
            user    => $user,
            url     => $url,
            comment => 'Updated Comment',
        });

        ok $bookmark;
        is $bookmark->user_id, $user->user_id;
        is $bookmark->entry->url, $url;
        is $bookmark->comment, 'Updated Comment';
    };
}
```

##  テスト用パッケージを書いておくと便利

* すべてのテスト用スクリプトから use する
* 本番とは別のテスト用データベースの dsn を設定する
* HTTP アクセスしないフラグを立てる、等々
* Intern-Diaryでは既に `t/lib/Intern/Diary.pm` に置いてあります

``` perl
package Test::Intern::Bookmark;

use strict;
use warnings;
use utf8;

use Path::Class;
use lib file(__FILE__)->dir->subdir('../../../../lib')->stringify;
use lib glob file(__FILE__)->dir->subdir('../../../../modules/*/lib')->stringify;

use DateTime;
use DateTime::Format::MySQL;

BEGIN {
    $ENV{INTERN_BOOKMARK_ENV} = 'test';
    $ENV{PLACK_ENV} = 'test';
    $ENV{DBI_REWRITE_DSN} ||= 1;
}

use DBIx::RewriteDSN -rules => q<
    ^(.*?;mysql_socket=.*)$ $1
    ^.*?:dbname=([^;]+?)(?:_test)?(?:;.*)?$ dbi:mysql:dbname=$1_test;host=localhost
    ^(DBI:Sponge:)$ $1
    ^(.*)$ dsn:unsafe:got=$1
>;

sub import {
    my $class = shift;

    strict->import;
    warnings->import;
    utf8->import;

    set_output();

    my $code = q[
        use Test::More;
    ];
    eval $code;
    die $@ if $@;
}

sub set_output {
    # http://blog.64p.org/entry/20081026/1224990236
    # utf8 hack.
    require Test::More;
    binmode Test::More->builder->$_, ":utf8"
        for qw/output failure_output todo_output/;
    no warnings 'redefine';
    my $code = \&Test::Builder::child;
    *Test::Builder::child = sub {
        my $builder = $code->(@_);
        binmode $builder->output,         ":utf8";
        binmode $builder->failure_output, ":utf8";
        binmode $builder->todo_output,    ":utf8";
        return $builder;
    };
}

1;

```

## 心構え: テストは安心して実行できるように

* 本番の DB にアクセスしないようにする
  * テスト専用の DB を用意して、テストでは必ずそちらを使うようにする
  * [DBIx::RewriteDSN](http://search.cpan.org/~satoh/DBIx-RewriteDSN/lib/DBIx/RewriteDSN.pm) を使う
* 外部との通信を発生させない
  * テストの高速化にもつながります

## ディレクトリ構成

``` text
.
├── README.md
├── cpanfile
├── db
│   └── schema.sql
├── lib
│   └── Intern
│        ├── Bookmark
│        │   ├── Config # WAFの授業で使います
│        │   │   ├── Route
│        │   │   │   └── Declare.pm
│        │   │   └── Route.pm
│        │   ├── Config.pm
│        │   ├── Context.pm
│        │   ├── Engine # WAFの授業で使います
│        │   │   ├── API.pm
│        │   │   ├── Bookmark.pm
│        │   │   └── Index.pm
│        │   ├── Model
│        │   │   ├── Bookmark.pm
│        │   │   ├── Entry.pm
│        │   │   └── User.pm
│        │   ├── Request.pm # WAFの授業で使います
│        │   ├── Service
│        │   │   ├── Bookmark.pm
│        │   │   ├── Entry.pm
│        │   │   └── User.pm
│        │   ├── Util.pm
│        │   └── View # WAFの授業で使います
│        │       └── Xslate.pm
│        └── Bookmark.pm
├── script
│   ├── app.psgi # WAFの授業で使います
│   ├── appup    # WAFの授業で使います
│   ├── appup.pl # WAFの授業で使います 
│   └── setup_db.sh
├── t
│   ├── engine # WAFの授業で使います
│   │   ├── api.t
│   │   ├── bookmark.t
│   │   └── index.t
│   ├── lib
│   │   └── Test
│   │       └── Intern
│   │           ├── Bookmark
│   │           │   ├── Factory.pm
│   │           │   └── Mechanize.pm
│   │           └── Bookmark.pm
│   ├── model
│   │   ├── bookmark.t
│   │   ├── entry.t
│   │   └── user.t
│   ├── object
│   │   ├── config.t
│   │   ├── dbi-factory.t
│   │   └── util.t
│   └── service
│       ├── bookmark.t
│       ├── entry.t
│       └── user.t
└── templates # WAFの授業で使います
    ├── _wrapper.tt
    ├── bookmark
    │   ├── add.html
    │   └── delete.html
    ├── bookmark.html
    └── index.html

24 directories, 45 files

```


## 課題2

CLIでデータベースに日記を記録するIntern-Diaryを作りましょう。
基本的な処理の流れはbookmark.plを参考にするとよいでしょう。

* (必須)モデルクラスを定義してみてください
* (必須)考えたクラスを元にデータベースのテーブルスキーマをSQLで記述してください
  * SQLはdb/schema.sql というファイルに書いてください
  * できたら先に進む前にメンターに見てもらってください
* (必須)データベースに日記を記録するCLI版 Intern-Diaryを作って下さい
* (オプション)テストを書いてください(できるだけがんばろう)
* (オプション)アプリケーションに独自の機能を追加してみてください
  * 記事のカテゴリ分け機能
    * ヒント: 多対多リレーションの活用
  * 検索
    * ヒント: `LIKE`演算子
  * マルチユーザ化

### mysqldump お願い

評価のため mysqldump もお願いします。

保存先は mysqldump ディレクトリに

``` text
$ mkdir mysqldump
$ mysqldump -uroot -Q intern_diary_$USER > mysqldump/intern_diary_$USER.sql
```

これも commit, push してください。

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/2.1/jp/"><img alt="クリエイティブ・コモンズ・ライセンス" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/2.1/jp/88x31.png" /></a><br />この 作品 は <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/2.1/jp/">クリエイティブ・コモンズ 表示 - 非営利 - 継承 2.1 日本 ライセンスの下に提供されています。</a>
