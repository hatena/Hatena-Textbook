# Scala によるデータベースプログラミング

## Scala(Java) から RDBMS を使う: JDBC

* Java からデータベース管理システムに接続する最も基本的なモジュール
* [JDBC](https://ja.wikipedia.org/wiki/JDBC)
  * DriverでRDBMSの差を吸収して統一的なインターフェイスを提供する
  * MySQL、PostgreSQL、H2、…

## JDBC を用いる

* JDBCでRDBMSとやり取りする最も素朴な方法
  * プレースホルダ機能
  * プリペアードステートメント機能

<!-- build.sbt
scalaVersion := "2.11.6"

libraryDependencies += "mysql" % "mysql-connector-java" % "5.1.35"
-->

``` scala
import java.sql.{Connection, ResultSet, Statement, PreparedStatement, DriverManager}

object Main {
   def main(args: Array[String]) {
     val conn: Connection = DriverManager.getConnection("jdbc:mysql://localhost/vocaloid", "nobody", "nobody")

     val st: PreparedStatement = conn.prepareStatement("SELECT * FROM artist WHERE birthday < ? ORDER BY birthday ASC")
     st.setString(1, "2008-01-01")
     val rs: ResultSet = st.executeQuery()

     while (rs.next()) {
       println(s"""${rs.getInt("id")}, ${rs.getString("name")}, ${rs.getString("birthday")}""")
     }
     rs.close()
     st.close()
     conn.close()
   }
}

// =>
// 1, 初音ミク, 2007-08-31
// 2, 鏡音リン, 2007-12-27
// 3, 鏡音レン, 2007-12-27

```

## より便利なモジュール

以下のようなモジュールを使います

* [Slick](http://slick.typesafe.com)
  * Functional Relational Mapping Library
  * Reactive
    * サンプルコードでは簡単のため Reactive な書き方はしてない
  * Plain SQL
* [HikariCP](https://github.com/brettwooldridge/HikariCP)
  * コネクションプーリング

<!-- build.sbt
scalaVersion := "2.11.6"

libraryDependencies ++= Seq(
  "com.typesafe.slick" % "slick_2.11" % "3.0.0",
  "com.zaxxer" % "HikariCP-java6" % "2.3.3",
  "mysql" % "mysql-connector-java" % "5.1.35",
  "org.slf4j" % "slf4j-nop" % "1.6.4"
)
-->
<!-- src/main/resources/application.conf
db.default = {
  driver="com.mysql.jdbc.Driver"
  url="jdbc:mysql://localhost/vocaloid"
  user="root"
  password=""
}
-->

```scala
import scala.concurrent.{Future, Await}
import scala.concurrent.duration.Duration
import scala.concurrent.ExecutionContext.Implicits.global
import slick.driver.MySQLDriver.api._

object Main {
  def main(args: Array[String]) {
    val db = Database.forConfig("db.default")

    val name = "初音ミク"

    Await.result(
      db.run(
        sql"""SELECT * FROM artist WHERE name = ${name} LIMIT 1""".as[(Int, String, String)]
      ).map(println),
      Duration.Inf
    )
  }
}
```

## 得られたデータをCase Classに変換する

* 対応するレコードを表すCase Class のインスタンスに変換すると便利
* 例:
  * artistテーブルに対応するArtistケースクラス
  * albumテーブルに対応するAlbumケースクラス

```scala
  import scala.concurrent.{Future, Await}
  import scala.concurrent.duration.Duration
  import scala.concurrent.ExecutionContext.Implicits.global
  import slick.driver.MySQLDriver.api._
  import org.joda.time.LocalDate
  import slick.jdbc.GetResult
  import com.github.tototoshi.slick.MySQLJodaSupport._

  case class Artist(id: Long, name: String, birthday: LocalDate)

  def main(args: Array[String]) {
    val db = Database.forConfig("db.default")

    val name = "初音ミク"

    Await.result(
      db.run(
        sql"""SELECT * FROM artist WHERE name = ${name} LIMIT 1""".as[Artist]
      ).map(println),
      Duration.Inf
    )
  }
  implicit val userGetResult = GetResult(r => Artist(r.<<, r.<<, r.<<))
  //implicit val userGetResult = GetResult(r => Artist(r.nextInt, r.nextString, new LocalDate(r.nextString)))
```

## Slick+独自拡張

* Future を使ったコードを書くのは面倒

<!--  * Monad Transformer とか使えば綺麗に書ける -->

* 今回はSQLに集中してもらうため 同期的に使えるようにした [ラッパー](../../../../../hatena/scala-Intern-Bookmark/blob/master/src/main/scala/internbookmark/repository/package.scala) を通して使う

```scala
  def find(userId: Long)(implicit ctx: Context): Option[User] = run(
    sql"""SELECT * FROM user WHERE id = $userId LIMIT 1""".as[User].map(_.headOption)
  )
```


## Slick によるSQL発行

* ここから説明する方法を使ってクエリを発行しよう

## 条件に合う一行を取得 `sql`

``` scala

val name = "初音ミク"
val artist: Option[Artist] = run(
  sql"""SELECT * FROM artist
          WHERE name = ${name}
          LIMIT 1""".as[Artist]
).headOption

println artist
```

``` sql
SELECT * FROM artist WHERE name = '初音ミク' LIMIT 1;
```

<table>
  <tr><th>id</th><th>name</th><th>birthday</th></tr>
  <tr><td>1</td><td>初音ミク</td><td>2007-08-31</td></tr>
</table>


## 条件に合う行を複数取得 `sql`

``` scala
val name = "鏡音%"
val limit = 10
val offset = 0
val artists: Seq[Artist] = run(
  sql"""SELECT * FROM artist
          WHERE name LIKE ${name}
          ORDER BY id ASC
          LIMIT ${limit}
          OFFSET ${offset}""".as[Artist]
)

artist.foreach(println)
```

``` sql
SELECT * FROM artist WHERE name LIKE '鏡音%' ORDER BY id ASC LIMIT 10 OFFSET 0;
```

<table>
  <tr><th>id</th><th>name</th><th>birthday</th></tr>
  <tr><td>2</td><td>鏡音リン</td><td>2007-12-27</td></tr>
  <tr><td>3</td><td>鏡音レン</td><td>2007-12-27</td></tr>
</table>

## 行の挿入 `sqlu`

``` scala
val id = 5
val name = "重音テト"
val birthday = "2008-04-02"
run(
  sqlu"""
    INSERT INTO artist
      SET
        id       = ${id},
        name     = ${name},
        birthday = ${birthday}"""
)
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

## 行の更新 `sqlu`

```scala
val name = "弱音ハク"
val id   = 1
run(
  sqlu"""
    UPDATE artist
      SET
        name = ${name}
      WHERE
        id = ${id}"""
)
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

## 行の削除 `sqlu`

```scala
val id = 1
run(
  sqlu"""
    DELETE FROM artist
      WHERE
        id = ${id}"""
)
```

``` sql
DELETE FROM artist WHERE id = 1;
```
<table>
  <tr><th>id</th><th>name</th><th>birthday</th></tr>
  <tr><td>2</td><td>鏡音リン</td><td>2007-12-27</td></tr>
  <tr><td>3</td><td>鏡音レン</td><td>2007-12-27</td></tr>
  <tr><td>4</td><td>巡音ルカ</td><td>2009-01-30</td></tr>
  <tr><td>5</td><td>重音テト</td><td>2008-04-01</td></tr>
</table>

## セキュリティ

* データベースの脆弱性は致命的
* データの漏洩、損失
* 気をつけましょう

## 悪い例

```scala
val name = "..." // ユーザの入力

val st: PreparedStatement = conn.prepareStatement(
  s"SELECT * FROM artist WHERE name = $name",
)
...
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

## 実践編 `internbookmark.cli.BookmarkCLI`

* 実践編です
* 小さなブックマークアプリを書いていく過程を見ていきます

## 大まかな機能

* ユーザは URL (エントリ) を個人のブックマークに追加し、コメントを残せる
* エントリはユーザに共通の情報を持つ (ページタイトルなど)
* とりあえず一人用で (マルチユーザも視野にいれつつ)

## add, list, delete

* run add &lt;<var>url</var>&gt; [コメント]
  * ブックマークを追加


``` text
> run add http://www.yahoo.co.jp/ ヤッホー
Bookmarked [8] Yahoo! JAPAN <http://www.yahoo.co.jp/>
    @2011-08-16 ヤッホー
```

* run list
  * ブックマークの一覧を出力


``` text
> run list
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

* run delete &lt;<var>url</var>&gt;
  * ブックマークを削除


``` text
> run delete http://www.google.com/
Deleted
```

## では作ってみましょう

コードを手元にもってきて試してみましょう

``` text
$ git clone https://github.com/hatena/scala-Intern-Bookmark
$ cd scala-Intern-Bookmark
$ sbt
> run
```

## データのモデリング

データベーススキーマを考える前にどのようなデータが登場するか整理してみよう。

## 登場する概念(モデル)

* `User` ブックマークをするユーザ
* `Entry` ブックマークされた記事(URL)
* `Bookmark` ユーザが行ったブックマーク

###  概念同士の関係(クラス図)

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
  <tr><td>1</td><td>jkondo</td></tr>
  <tr><td>2</td><td>chris4403</td></tr>
  <tr><td>3</td><td>motemen</td></tr>
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
  <tr><td>1</td><td>1 (= jkondo)</td><td>1 (= example.com)</td><td>例示用ドメインですね</td></tr>
  <tr><td>2</td><td>1</td><td>2 (= はてな)</td><td>はてな〜。</td></tr>
  <tr><td>3</td><td>2 (= chris4403)</td><td>3 (= motemen.com)</td><td>モテメンさんのホームページですね</td></tr>
  <tr><td>4</td><td>3 (= motemen)</td><td>3</td><td>僕のホームページです</td></tr>
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
| アプリケーション層 | ドメイン層の機能を同士を組み合わせる層 |
| ドメイン層 | インフラ層の機能を使いプログラムの役立つ機能を実装する層 |
| インフラ層 | DBやネットワークなどプログラムの外部機能とやりとりする層 |

* 今回は規模が小さいのでアプリケーション層は使わない.

## ServiceとModel
はてなでよく使われている、ドメイン層を整理するための設計方法の一つ。

* Model: モデルを抽象化した単純なオブジェクト
* Service: モデルに含めることが出来ないインフラ層とのやり取りを実装するモジュール

Modelを単純なオブジェクトにすることで見通しがよくなる。

## `internbookmark.cli.BookmarkCLI`の構造

* **`internbookmark.cli.BookmarkCLI` は最小限の処理に**
  * ドメインロジックはドメイン層であるmodelとserviceに集約
  * `add_bookmark` や `list_bookmarks`などのコマンドはmodelと serviceを組み合わせるだけ
  * 引数からコマンドを受け付ける部分 = インターフェース層

[BookmarkCLI.scala](../../../../../hatena/scala-Intern-Bookmark/blob/master/src/main/scala/internbookmark/cli/BookmarkCLI.scala)

## modelの実装

* モデルを抽象化した単純なケースクラス
  * テーブルの1レコードがmodelの1オブジェクトになることが多い
* 副作用はなく、状態を持たない
  * **ここからデータベースへアクセスしない** ように注意
  * 思っても見ないところからDBアクセスが行われないように

``` scala
package internbookmark.model

import org.joda.time.DateTime

case class User(id: Long, name: String, createdAt: DateTime, updatedAt: DateTime)
```

* その他 Entry, Bookmark も同じように

## serviceの実装
* サービスはリポジトリを使ってアプリケーションのコアロジックを実装する.

[BookmarkApp.scala](../../../../../hatena/scala-Intern-Bookmark/blob/master/src/main/scala/internbookmark/service/BookmarkApp.scala)

## repositoryの実装
データベースなどのやり取りを実装するインフラ層のモジュール。

* SQLを実行するのはrepositoryからのみ
* repositoryのメソッドは、必要に応じてModelのオブジェクトを返す

[Bookmarks.scala](../../../../../hatena/scala-Intern-Bookmark/blob/master/src/main/scala/internbookmark/repository/Bookmarks.scala)

どんなSQLが使えるか考えてみよう。

``` scala
// ブックマーク一覧
// SELECT * FROM bookmark WHERE user_id = ... のようなSQLを使って実装
val bookmarks = internbookmark.service.Bookmark.searchBookmarksByUser(user)

// ブックマーク追加
// INSERT INTO bookmark ... のようなSQLを使って実装
internbookmark.service.Bookmark.addBookmark(user, url, comment)

// ブックマーク削除
// DELETE FROM bookmark WHERE id = ... のようなSQLを使って実装
internbookmark.service.Bookmark.deleteBookmarkByUrl(user, url)
```

* いきなり実装を書くのは難しい？
  * 案1: とりあえずテストを書いてみる
  * 案2: とりあえず一番外側のスクリプトを書いてみる
* REPL で試しながら少しずつ実装する (sbt console)

## プログラムの設計のまとめ

* レイヤ化アーキテクチャを意識
* repositoryにはDBへのアクセスを書く
  * **modelからDBにアクセスしない**
* modelはテーブルのレコードを表現する
* service でアプリケーションのコアロジックを実装する
* `internbookmark.cli.BookmarkCLI` ではserviceのメソッドを呼び出し、modelを表示する
* scala-Intern-Bookmarkをよく読もう

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

* [ScalaTest](http://scalatest.org/) というテストフレームワークを使っています

* [BookmarkAppSpec.scala](../../../../../hatena/scala-Intern-Bookmark/blob/master/src/test/scala/internbookmark/service/BookmarkAppSpec.scala)

##  テスト用パッケージを書いておくと便利

* すべてのテスト用スクリプトから import する
* 事前条件をセットするユーティリティ(ユーザーを作る、エントリを用意するなど) [Factory.scala](../../../../../hatena/scala-Intern-Bookmark/blob/master/src/test/scala/internbookmark/helper/Factory.scala)
* HTTP アクセスしないフラグを立てる、等々[EntriesDBForTest.scala](../../../../../hatena/scala-Intern-Bookmark/blob/master/src/test/scala/internbookmark/helper/EntriesDBForTest.scala)

## 心構え: テストは安心して実行できるように

* 本番の DB にアクセスしないようにする
  * テスト専用の DB を用意して、テストでは必ずそちらを使うようにする
  * [test.conf](../../../../../hatena/scala-Intern-Bookmark/tree/master/src/test/resources/test.conf)
* 外部との通信を発生させない
  * テストの高速化/自動化にもつながります

## ディレクトリ構成

``` text
scala-Intern-Bookmark/
├── .gitignore
├── README.md
├── build.sbt
├── db/
│   └── schema.sql
├── project/
│   ├── build.properties
│   └── plugins.sbt
├── script/
│   └── setup.sh
└── src/
    ├── main/
    │   ├── resources/
    │   │   ├── application.conf
    │   │   └── logback.xml
    │   ├── scala/
    │   │   ├── HatenaOAuth.scala # WAF の講義で使います
    │   │   ├── ScalatraBootstrap.scala # WAF の講義で使います
    │   │   ├── internbookmark/
    │   │   │   ├── cli/
    │   │   │   │   └── BookmarkCLI.scala
    │   │   │   ├── model/
    │   │   │   │   ├── Bookmark.scala
    │   │   │   │   ├── Entry.scala
    │   │   │   │   └── User.scala
    │   │   │   ├── repository/
    │   │   │   │   ├── Bookmarks.scala
    │   │   │   │   ├── Context.scala
    │   │   │   │   ├── Entreis.scala
    │   │   │   │   ├── Identifier.scala
    │   │   │   │   ├── TitleExtractor.scala
    │   │   │   │   ├── TitleExtractorDispatch.scala
    │   │   │   │   ├── Users.scala
    │   │   │   │   ├── db/
    │   │   │   │   │   └── JdbcBackend.scala
    │   │   │   │   └── package.scala
    │   │   │   ├── service/
    │   │   │   │   ├── BookmarkApp.scala
    │   │   │   │   ├── Error.scala
    │   │   │   │   ├── Json.scala
    │   │   │   │   └── package.scala
    │   │   │   └── web/ # WAF の講義で使います
    │   │   └── slick/
    │   │       └── jdbc/
    │   │           └── TransactionalJdbcBackend.scala
    │   ├── twirl/ # WAF の講義で使います
    │   └── webapp/ # WAF の講義で使います
    └── test/
        ├── resources/
        │   └── test.conf
        └── scala/
            └── internbookmark/
                ├── helper/
                │   ├── EntriesDBForTest.scala
                │   ├── Factory.scala
                │   ├── SetupDB.scala
                │   ├── UnitSpec.scala
                │   └── WebUnitSpec.scala # WAF の講義で使います
                ├── service/
                │   └── BookmarkAppSpec.scala
                └── web/ # WAF の講義で使います
```


## 課題2

データベースに日記を記録するCLI版 Intern-Diaryを作りましょう。

* 必須課題(1点)
  * モデルクラスを定義してみてください
  * 考えたクラスを元にデータベースのテーブルスキーマをSQLで記述してください
    * SQLはdb/schema.sql というファイルに書いてください
    * できたら先に進む前にメンターに見てもらってください
  * データベースに日記を記録するCLI版 Intern-Diaryを作って下さい
* オプション課題(1点)
  * テストを書いてください(できるだけがんばろう)
* オプション課題(1点)
  * アプリケーションに独自の機能を追加してみてください
    * (例)記事のカテゴリ分け機能
      * ヒント: 多対多リレーションの活用
    * (例)検索
      * ヒント: `LIKE`演算子
    * (例)マルチユーザ化


### 課題提出

https://github.com/hatena/scala-Intern-Diary にひな形があるので fork して開発しましょう。
課題提出時は元ブランチへ Pull-Request を送ってください。

### mysqldump のお願い

評価のため mysqldump もお願いします。

保存先は mysqldump ディレクトリに

``` text
$ mkdir mysqldump
$ mysqldump -uroot -Q intern_diary_$USER > mysqldump/intern_diary_$USER.sql
```

これも commit, push してください。

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/2.1/jp/"><img alt="クリエイティブ・コモンズ・ライセンス" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/2.1/jp/88x31.png" /></a><br />この 作品 は <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/2.1/jp/">クリエイティブ・コモンズ 表示 - 非営利 - 継承 2.1 日本 ライセンスの下に提供されています。</a>
