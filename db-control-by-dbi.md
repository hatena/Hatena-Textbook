# Perlでのデータベース操作

<!--
編集者ノート (Last Update: 2013年8月):
* 使うライブラリやDBMSの例は時代によって変わるため、毎年見直しが必要です。
* 課題の変更がある場合は Intern-Bookmark、Intern-Diary ディレクトリ構成の変更が必要です。
* ディレクトリ構成によっては サンプルの use lib を変更する必要があります。
* サンプルアプリのリポジトリURLが変更された場合はclone元を変更してください。
* 使用するMySQLのバージョンが変わった場合は参考リンクのリファレンスのURLを変更してください。
* この資料ではクラスの定義にClass::Accessor::Liteを使っています。デファクトから外れた場合は変更してください。
-->

## カリキュラム

* Perl & OOP
* <strong>Perlでのデータベース操作 ← いまここ</strong>
* WAF によるウェブアプリケーション開発
* JavaScript で学ぶイベントドリブン

## 今日は何をしますか

* アプリケーションでデータベースをいかに扱うかを理解する
* SQLを書けるようになる
* PerlからMySQLにアクセスする方法を学ぶ
* (課題) 来週以降の Web アプリのための下地づくり

## 今日の講義
* 基本編
  * データベースの基本的な概念や使い方を紹介します
* 実践編
  * PerlでMySQLにアクセスする方法を学ぶ
  * RDBMSを使った簡単なブックマーク管理ツールの作り方をなぞります
* 課題の解説

## 注意点

* 大変重要な講義です

* 駆け足で進みますのでがんばってついてきてください
* 質問があれば途中でも聞いてください
  * わからないところをメモっておいて後で聞くのも良いです

<!--
流行り廃りがあまり無い、長く使える知識です。
また、データベースはボトルネックになりやすく、良いプログラムを書くために必要な知識が多いです。
データベース周りのセキュリティ脆弱性は命取りとなりますし、非常に重要な講義です。
-->

## データベースとは

* データ (data) とは
* データベース (database) とは
  * = データの集合

<!--
データ = 情報化されたもの
データベース = データを集合として扱いやすくしたもの

データベースは広義ではコンピュータ上のものに限らない。
たとえば辞書は単語のデータベース。タウンページは電話番号データベース。

この後はコンピュータ上のデータベースについて解説します。
-->

## 簡単なデータベースの例

<div style="text-align: center"><img src="http://cdn-ak.f.st-hatena.com/images/fotolife/m/motemen/20110816/20110816202128.gif"></div>

* 2ちゃんねるの機能
  * 多くの鯖に分散されたスレッド
  * スレッドを閲覧
  * スレッドの最後にレスを追加
  * スレッドを立てる
* データストレージ = dat ファイル (1 行 1 レス)

``` text
名無しさん<>sage<>2011/08/19(金) 06:19:10.13 <> &gt;&gt;1乙 <>
名無しさん<>sage<>2011/08/19(金) 06:21:30.21 <> こんにちは <>
```

* このようなデータベースは簡単だが、デメリットはあるだろうか？

## 2ちゃんねる+αを考えてみる

2ちゃんねるの機能追加をするなら

* ユーザ認証: 過去の書き込みを一覧できるように
  * → dat ファイルにユーザ名を記録して、一覧するときに全部検索？
* 耐障害性: マシンが一台故障してもサービスが継続できるように
  * → dat ファイルを複数のマシンにコピーする？

<!--
datファイルはただのテキストファイルなので、一行ずつ順番にしか読み取ることができず効率が悪い
-->

* 面倒

### 一般にウェブサービスは成長します

* データは大量・増える一方
* アクセスも増える一方
* サービスは 24 時間 365 日提供したい
* データは消えてはならない

##  そのための データベース管理 です

* データベース管理システム (DataBase Management System = DBMS)

* **データの抽象化**
  * データがディスクにどのように格納されているかを意識する必要はない
* **効率が良い**
* **並列アクセス可能に**
  * トランザクション・ロック機構がある
  * 並列にアクセスするアプリでも、利用するときは一つの接続のみを考えていれば良い
* **クラッシュ時復帰** (データ損失を防ぐ)
  * 停電などによりサーバが死ぬとか起こりえる
  * ファイルシステムにそのまま記録する場合、書込み中だと書き込もうとした内容が中途半端だったり、消失したりすることが起こりえる

## いろんなDBMS知ってますか?

* [リレーショナルDBMS](http://ja.wikipedia.org/wiki/%E9%96%A2%E4%BF%82%E3%83%87%E3%83%BC%E3%82%BF%E3%83%99%E3%83%BC%E3%82%B9%E7%AE%A1%E7%90%86%E3%82%B7%E3%82%B9%E3%83%86%E3%83%A0)
  * SQLite / MySQL / PostgreSQL
  * <a href="http://www.postgresql.org/files/postgresql.mp3" target="_blank">http://www.postgresql.org/files/postgresql.mp3</a>
* カラム指向DBMS
  * BigTable / Apache Cassandra / Apache HBase
* [ドキュメント指向DBMS](http://ja.wikipedia.org/wiki/Category:%E3%83%89%E3%82%AD%E3%83%A5%E3%83%A1%E3%83%B3%E3%83%88%E6%8C%87%E5%90%91%E3%83%87%E3%83%BC%E3%82%BF%E3%83%99%E3%83%BC%E3%82%B9)
  * MongoDB / Apache CouchDB
* オブジェクト指向DBMS
  * KiokuDB (Perl) / AllegroCache (Common Lisp)
* グラフDBMS
  * AllegroGraph (Common Lisp)

<!--
データベースの「管理」の仕方 (データモデル) によってDBMSには種類がある。

RDBMS以外のDBMSを「NoSQL (Not only SQL)」と言う。

* リレーショナルDBMSは「関係モデル」の形式で管理する。SQLというANSI標準化された組み込み言語でアクセスでき、最も普及しているDBMS。
  * SQLiteはアプリケーション組み込みのDBMSとして異色なので詳しく説明しても良い。
  * サーバではなくライブラリ
  * 書き込み処理でデータベース全体がロックされる
  * 複数ユーザのアクセスが必要なく、データ量があまり多くならない場合は検討しても良い
  * iOSやAndroidなどでも利用されている
* カラム指向DBMSはRDBMSのようにテーブルで管理するが、列ごとの高速な読み込みに長けている。ある程度カラム追加の自由が利くものもある。
* ドキュメント指向DBMSは、ドキュメントと呼ばれる単位でレコードを記録できる。カラムは行ごとに自由に追加できるため、この中では最も自由度が高い。CouchDBはJSON形式、MongoDBはBSONというJSONを拡張した形式で記録する。
* オブジェクト指向DBMSはオブジェクトをそのまま永続化できるという、アプリケーション寄りのDBMSである。一般のORMと異なる点は、保存せずとも暗黙的に変更が永続化されることである。RDBMSをバックエンドとする実装もあるが数倍低速であり、BerkeleyDBのような組み込みDBを使うことを前提としているものが多い
* グラフDBMSは各レコードが蜘蛛の巣上に繋がったようなグラフデータを検索するために使うDBMS。
-->

* ここではRDBとRDBMSのみ言及する。

##  関係データベースとは？

*  関係モデルに基づくデータベース

##  関係モデル

* 関係は属性を持った組 (タプル) の集合で表される

``` text
R: (ID, 名前, 誕生日) = {
  (1, 初音ミク, 2007-08-31),
  (2, 鏡音リン, 2007-12-27),
  (3, 鏡音レン, 2007-12-27),
  (4, 巡音ルカ, 2009-01-30)
}
```

<!--
属性 = ID, 名前, 誕生日
組 (タプル) = (1, 初音ミク, 2007-08-31
関係 (テーブル) = { ... }
-->

* 関係は一般的に「テーブル (表)」と呼ばれる

<!--
これは定義的な説明なので、軽く流して良い
-->

##  関係データベース

* 実際のRDBMS
* データベース は複数の「テーブル (表)」を持つ
* データは「レコード (列)」で表される
  * レコードは「カラム (属性) 」を持つ

### artist テーブル:

<table>
  <tr><th>id</th><th>name</th><th>birthday</th></tr>
  <tr><td>1</td><td>初音ミク</td><td>2007-08-31</td></tr>
  <tr><td>2</td><td>鏡音リン</td><td>2007-12-27</td></tr>
  <tr><td>3</td><td>鏡音レン</td><td>2007-12-27</td></tr>
  <tr><td>4</td><td>巡音ルカ</td><td>2009-01-30</td></tr>
</table>

### album テーブル:

<table>
  <tr><th>id</th><th>artist_id</th><th>name</th><th>released_on</th></tr>
  <tr><td>1</td><td>1</td><td>みくのかんづめ</td><td>2008-12-03</td></tr>
</table>

## SQLで関係を定義する

* SQL という組み込み言語によりデータベースの問い合わせ、更新などを行う
* SQLは標準化されており、ほとんどのRDBMSで使うことができる

### artist テーブル:

<table>
  <tr><th>id</th><th>name</th><th>birthday</th></tr>
  <tr><td>1</td><td>初音ミク</td><td>2007-08-31</td></tr>
  <tr><td>2</td><td>鏡音リン</td><td>2007-12-27</td></tr>
  <tr><td>3</td><td>鏡音レン</td><td>2007-12-27</td></tr>
  <tr><td>4</td><td>巡音ルカ</td><td>2009-01-30</td></tr>
</table>

``` sql
CREATE TABLE artist (
  id INTEGER NOT NULL AUTO_INCREMENT,
  name VARCHAR(32),
  birthday DATE
);
```

### album テーブル:

<table>
  <tr><th>id</th><th>artist_id</th><th>name</th><th>released_on</th></tr>
  <tr><td>1</td><td>1</td><td>みくのかんづめ</td><td>2008-12-03</td></tr>
</table>

``` sql
CREATE TABLE album (
  id INTEGER NOT NULL AUTO_INCREMENT,
  artist_id INTEGER,
  name VARCHAR(128),
  released_on DATE
);
```

## SQLでテーブルのCRUD

* CRUD = Create & Read & Update & Delete
* 基本的なデータベース操作をできるようになろう

``` sql
INSERT INTO artist (id, name, birthday) VALUES (5, '重音テト', '2008-04-01');
INSERT INTO artist SET id = 5, name = '重音テト', birthday = '2008-04-01';
```

``` sql
SELECT birthday FROM artist WHERE name = '初音ミク';
SELECT * FROM artist WHERE birthday < '2009-01-01' ORDER BY birthday DESC;
```

``` sql
UPDATE artist SET birthday = '2008-07-18' WHERE name LIKE '鏡音%';
```

``` sql
DELETE FROM artist WHERE id = 4;
```

* 動詞 (SELECT, INSERT, UPDATE, DELETE)
* 対象: WHERE …

## SELECT文

* 最も使う文だが、かなり複雑
* すべては説明できません
* See [MySQL 5.5 Reference Manual :: 13.2.9 SELECT Syntax](http://dev.mysql.com/doc/refman/5.5/en/select.html).

```
SELECT
    [ALL | DISTINCT | DISTINCTROW ]
      [HIGH_PRIORITY]
      [STRAIGHT_JOIN]
      [SQL_SMALL_RESULT] [SQL_BIG_RESULT] [SQL_BUFFER_RESULT]
      [SQL_CACHE | SQL_NO_CACHE] [SQL_CALC_FOUND_ROWS]
    select_expr [, select_expr ...]
    [FROM table_references
    [WHERE where_condition]
    [GROUP BY {col_name | expr | position}
      [ASC | DESC], ... [WITH ROLLUP]]
    [HAVING where_condition]
    [ORDER BY {col_name | expr | position}
      [ASC | DESC], ...]
    [LIMIT {[offset,] row_count | row_count OFFSET offset}]
    [PROCEDURE procedure_name(argument_list)]
    [INTO OUTFILE 'file_name'
        [CHARACTER SET charset_name]
        export_options
      | INTO DUMPFILE 'file_name'
      | INTO var_name [, var_name]]
    [FOR UPDATE | LOCK IN SHARE MODE]]
```

## 練習問題1: WHERE節

* `id`が4の`artist`は？

<table>
  <tr><th>id</th><th>name</th><th>birthday</th></tr>
  <tr><td>1</td><td>初音ミク</td><td>2007-08-31</td></tr>
  <tr><td>2</td><td>鏡音リン</td><td>2007-12-27</td></tr>
  <tr><td>3</td><td>鏡音レン</td><td>2007-12-27</td></tr>
  <tr><td>4</td><td>巡音ルカ</td><td>2009-01-30</td></tr>
</table>

* `WHERE` 使えますか

<br><br><br>

``` sql
SELECT * FROM artist WHERE id = 4;
```

<table>
  <tr><th>id</th><th>name</th><th>birthday</th></tr>
  <tr><td>4</td><td>巡音ルカ</td><td>2009-01-30</td></tr>
</table>

## 練習問題2: WHERE節 (2)

* `name`が「巡音ルカ」ではない`artist`の`name`は？

<table>
  <tr><th>id</th><th>name</th><th>birthday</th></tr>
  <tr><td>1</td><td>初音ミク</td><td>2007-08-31</td></tr>
  <tr><td>2</td><td>鏡音リン</td><td>2007-12-27</td></tr>
  <tr><td>3</td><td>鏡音レン</td><td>2007-12-27</td></tr>
  <tr><td>4</td><td>巡音ルカ</td><td>2009-01-30</td></tr>
</table>

* not equal は `!=`

<br><br><br>

``` sql
SELECT name FROM artist WHERE name != '巡音ルカ';
SELECT name FROM artist WHERE name <> '巡音ルカ'; -- 同じ
```

<table>
  <tr><th>name</th></tr>
  <tr><td>初音ミク</td></tr>
  <tr><td>鏡音リン</td></tr>
  <tr><td>鏡音レン</td></tr>
</table>

* 「\*」ではなく必要なフィールドのみ指定するほうが転送量が減って良い

## 練習問題3: WHERE節 (3)

* `id`が`1`か`2`か`4`である`artist`は？

<table>
  <tr><th>id</th><th>name</th><th>birthday</th></tr>
  <tr><td>1</td><td>初音ミク</td><td>2007-08-31</td></tr>
  <tr><td>2</td><td>鏡音リン</td><td>2007-12-27</td></tr>
  <tr><td>3</td><td>鏡音レン</td><td>2007-12-27</td></tr>
  <tr><td>4</td><td>巡音ルカ</td><td>2009-01-30</td></tr>
</table>

* 論理演算子`OR`

``` sql
SELECT * FROM artist
WHERE id = 1 OR id = 2 OR id = 4;
```

<table>
  <tr><th>id</th><th>name</th><th>birthday</th></tr>
  <tr><td>1</td><td>初音ミク</td><td>2007-08-31</td></tr>
  <tr><td>2</td><td>鏡音リン</td><td>2007-12-27</td></tr>
  <tr><td>4</td><td>巡音ルカ</td><td>2009-01-30</td></tr>
</table>

* `WHERE id IN (...)` と書くと複数のマッチングが同時にできる

``` sql
SELECT * FROM artist
WHERE id IN (1, 2, 4);
```

## 練習問題4: ORDER BY句

* 最も`birthday`が若い`artist`は誰か？

<table>
  <tr><th>id</th><th>name</th><th>birthday</th></tr>
  <tr><td>1</td><td>初音ミク</td><td>2007-08-31</td></tr>
  <tr><td>2</td><td>鏡音リン</td><td>2007-12-27</td></tr>
  <tr><td>3</td><td>鏡音レン</td><td>2007-12-27</td></tr>
  <tr><td>4</td><td>巡音ルカ</td><td>2009-01-30</td></tr>
</table>

* ソートする必要がある = `ORDER BY`

<br><br><br>

``` sql
SELECT * FROM artist ORDER BY birthday DESC LIMIT 1;
```

<table>
  <tr><th>id</th><th>name</th><th>birthday</th></tr>
  <tr><td>4</td><td>巡音ルカ</td><td>2009-01-30</td></tr>
</table>

* `DESC`は降順。`ASC`は昇順 (デフォルト)。
  * 昇順の場合は普通何も指定しません
* 1件しか必要ない場合は`LIMIT`を使うこと

## 練習問題5: LIMIT句, OFFSET句

* 2番目に`birthday`が若い`artist`は誰か？

<table>
  <tr><th>id</th><th>name</th><th>birthday</th></tr>
  <tr><td>1</td><td>初音ミク</td><td>2007-08-31</td></tr>
  <tr><td>2</td><td>鏡音リン</td><td>2007-12-27</td></tr>
  <tr><td>3</td><td>鏡音レン</td><td>2007-12-27</td></tr>
  <tr><td>4</td><td>巡音ルカ</td><td>2009-01-30</td></tr>
</table>

* `OFFSET N`を指定するとN行分読み飛ばす

<br><br><br>

``` sql
SELECT * FROM artist ORDER BY birthday DESC LIMIT 1 OFFSET 1;
```

<table>
  <tr><th>id</th><th>name</th><th>birthday</th></tr>
  <tr><td>3</td><td>鏡音レン</td><td>2007-12-27</td></tr>
</table>

## 練習問題6: GROUP BY

* `sex`ごとに`artist`数を出せ

<table>
  <tr><th>id</th><th>name</th><th>sex</th><th>birthday</th></tr>
  <tr><td>1</td><td>初音ミク</td><td>Female</td><td>2007-08-31</td></tr>
  <tr><td>2</td><td>鏡音リン</td><td>Female</td><td>2007-12-27</td></tr>
  <tr><td>3</td><td>鏡音レン</td><td>Male</td><td>2007-12-27</td></tr>
  <tr><td>4</td><td>巡音ルカ</td><td>Female</td><td>2009-01-30</td></tr>
</table>

* カラムの値によって分離したいときは`GROUP BY`を使う
* 数を集計したい場合は`COUNT`句を使う

<br><br><br>

``` sql
SELECT sex, COUNT(*) AS number_of_artists
FROM artist
GROUP BY sex;
```

<table>
  <tr><th>sex</th><th>number_of_artists</th></tr>
  <tr><td>Male</td><td>1</td></tr>
  <tr><td>Female</td><td>3</td></tr>
</table>

* フィールドに `AS ...` を指定すると結果テーブルのカラム名が変わる

## サブクエリ

<!--
ここはそれほど重要でないので軽く流しても良い
-->

* SELECT文の返り値をさらにSQL内に埋め込むことができます

* 「鏡音リン」と同じ`birthday`の`artist`の`name`は？
  * 2回に分けて考えよう
  1. 「鏡音リン」の`birthday`は？
  1. 1.の値と`birthday`が等しい`artist`は？

``` sql
SELECT birthday FROM artist WHERE name = '鏡音リン';
```

``` sql
SELECT name FROM artist
WHERE birthday = (SELECT birthday FROM artist WHERE name = '鏡音リン')
  AND name != '鏡音リン';
```

* サブクエリの結果が多くなる場合、メモリを大量に食うので注意が必要
* 慣れないうちは使うべきでない

## LEFT JOIN

<!--
ここはそれほど重要でないので軽く流しても良い
-->

* 「初音ミク」の`album`一覧が欲しい
* `album`テーブルには`artist_id`しかない
* LEFT JOIN

``` sql
SELECT album.name
FROM album LEFT JOIN artist ON album.artist_id = artist.id
WHERE artist.name = '初音ミク';
```

<table>
  <tr><th colspan="4">albumテーブル</th><th colspan="3">artistテーブル</th></tr>
  <tr><th>id</th><th>artist_id</th><th>name</th><th>released_on</th><th>id</th><th>name</th><th>birthday</th></tr>
  <tr><td>1</td><td>1</td><td>みくのかんづめ</td><td>2008-12-03</td><td>1</td><td>初音ミク</td><td>2007-08-31</td></tr>
</table>

* 他に `RIGHT JOIN`、`INNER JOIN`、`OUTER JOIN` などがあります

## トランザクション処理

* トランザクションは不可分な処理のまとまり
* 途中で失敗することが許されないデータアクセス群

### 例: 銀行の送金システム
  1. 元口座から1,000円引く
  1. 送金先の口座に1,000円足す
* いずれかが失敗するとデータに不整合が生じる
* 送金中にさらに送金しようとすると残額はどうなる？

## ここからが本番です

* 今までは基本知識です

<!--
インターン期間中ははてなの社員と同等のことを求められる場面も多いと思います
今までの知識を前提として、いかに良いコードを書けるか、を気にしてください
-->

* 応用編
  * より良いスキーマ設計
  * パフォーマンス
  * インデックス

## より良いスキーマ設計をするために

### カラムのデータ型

* カラムのデータ型、特に数値型は桁あふれに気をつけること
* MySQL 5.5の場合
  * INT: -2147483648 〜 2147483647
  * 21億レコードは意外とすぐに到達します
  * `id`は`BIGINT UNSIGNED`にしておくのが安全
    * 18446744073709551615 (1844京)
* ref [MySQL 5.5 Reference Manual :: 11 Data Types](http://dev.mysql.com/doc/refman/5.5/en/data-types.html)

### 制約

* レコードに必ず存在するカラムには`NOT NULL`制約をつける
* カラムがテーブル内で一意の場合は`UNIQUE KEY`制約をつける

``` sql
-- より良い定義
CREATE TABLE artist (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(32) NOT NULL,
  `birthday` DATE NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (id),
  UNIQUE KEY (name)
);

CREATE TABLE album (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `artist_id` BIGINT UNSIGNED NOT NULL,
  `name` VARCHAR(128) NOT NULL,
  `released_on` DATE NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (id),
  UNIQUE KEY (artist_id, name)
);
```

## テーブル間のリレーション

### 一対多のリレーション

<div style="text-align: center; background: #fff"><img src="http://cdn-ak.f.st-hatena.com/images/fotolife/n/nitro_idiot/20130812/20130812003717.png"></div>

* このスキーマでは`album`と`artist`は「一対多」
  * 一つの`album`に一人の`artist`しか対応づけられない
  * 一人の`artist`は複数の`album`を作れる

### 多対多のリレーション

<div style="text-align: center; background: #fff"><img src="http://cdn-ak.f.st-hatena.com/images/fotolife/n/nitro_idiot/20130812/20130812003716.png"></div>

* オムニバス形式の`album`を登録するには？

### album_artist_relationテーブル

``` sql
CREATE TABLE album_artist_relation (
  `album_id` BIGINT UNSIGNED NOT NULL,
  `artist_id` BIGINT UNSIGNED NOT NULL,

  PRIMARY KEY (album_id, artist_id)
);
```

## パフォーマンス

<!--
プログラムを書く上でパフォーマンスは当然気にされているとは思いますが、
データベース操作においては特に気をつける必要があります。
-->

* データベースはWebサービスにおいてボトルネックになりやすい
* 失敗するとサービスダウンにも
* 気をつけましょう

### データベースがボトルネックになる理由

* スケールがしづらい
* アプリケーションサーバはスケールしやすい
  * マシンリソースが必要な処理はアプリケーションサーバでやるほうが良い

## パフォーマンス対策

* 銀の弾丸はない
* アンチパターンはある

* クエリ数に気をつける
  * ワンクエリで取れるところはワンクエリで
    * ループ内でクエリ投げるとかやりがち
* 不要なクエリは投げない
  * なぜORMを使うべきでないか

<!--
なぜはてながORMを使うのを止めたか。
ORMはSQLを抽象化し、どんなSQLが、どこでいくつ発行されるかが明らかではない。
暗黙のうちにクエリを発行する。そしてこれはコストがかかる。

SQLをオブジェクト指向的な書き方をしても、必ずしも良いSQLにはならない。
→ オブジェクト指向インターフェイスでSQLを隠蔽しているのに、どんなSQLが発行されているか気にしないといけないという矛盾
開発は楽になるが、パフォーマンス改善はしづらい。

cho45「コストがかかることを抽象化して簡単にしてはならない」
-->

### 危ないクエリ

* JOIN
* サブクエリの利用

<!--
JOINやサブクエリはデータ量が多いとテンポラリ領域を使うため極端に遅くなる。
件数が多い場合はアプリケーション側で連結処理を書くほうが良い。
一般的にはWebアプリケーションで使われない。
ただし、バッチ処理などで使われることがある。
-->

## インデックス

* カラムの組み合わせについてインデックス (索引) を作成することができる
* キー (Key) とも言われる

* 普通のインデックス
  * そのカラムについて`ORDER BY`や`SELECT`したい時に
* ユニークキー
  * テーブル内で一意なキー (の組み合わせ)
* プライマリキー (主キー)
  * テーブル内で一意なキー
  * 最も高速

<!--
インデックスは複数指定することができます。そういうインデックスを複合インデックスと呼びます。
-->

### PRIMARY KEY

* テーブル内でレコードを一意に識別することができるカラム (任意)
  * 他のレコードと被ってはいけない (UNIQUE制約)
  * 値がなければいけない (NOT NULL制約)
* テーブルに1つだけ設定できる
* 「インデックス」(後述) として使える
* 「id」という名前

<!--
PRIMARY KEYは合ったほうが良いが、必ずしも「id」という名前やINTEGERである必要はない。
Active Record系のORMを使うと自動でこういったカラムになるためこれが慣習になっているが、
テーブルに対してユニークなもので変更が無いものなら良い。
「変更が無い」というのはサービスを運営していく上で必ずしも断言できないので、
自動インクリメントされる数値型にするのは無難な選択
(本当はINTEGERではなくBIGINT UNSIGNEDなどのほうが望ましいが複雑になるため便宜上INTEGERとしている)

たとえば「name」をPRIMARY KEYとしても良いかもしれない。
しかし、nameの変更がないにしても海外進出をしたときに「Hatsune Miku」という名前になったりし、
レコードに対して名前が一意にならなくなるケースも考えうる。
-->

``` sql
-- インデックスをつけてみる
CREATE TABLE artist (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARBINARY(32) NOT NULL,
  `birthday` DATE NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (id),
  UNIQUE KEY (name),
  KEY (birthday)
);

CREATE TABLE album (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `artist_id` BIGINT UNSIGNED NOT NULL,
  `name` VARCHAR(128) NOT NULL,
  `released_on` DATE NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (id),
  UNIQUE KEY (artist_id, name),
  KEY (name),
  KEY (released_on)
);
```

### インデックスのデメリットと、それを無視する理由

* インデックスを張ると、更新・削除時にオーバーヘッドがあるが…
* 一般的なアプリケーションでは 参照処理 ＞ 更新処理

## 語られなかったこと

* DISTINCT
* UNION句
* 外部キー (Foreign Key) 制約
* TRIGGER
* DBMSのユーザ管理と権限

## 休憩

## 第二部
* <del>基本編</del>
  * <del>データベースの基本的な概念や使い方を紹介します</del>
* **実践編**
  * PerlでMySQLにアクセスする方法を学ぶ
  * RDBMSを使った簡単なブックマーク管理ツールの作り方をなぞります
* 課題の解説

## Perl から RDBMS を使う: DBI

* Perl からデータベース管理システムに接続するモジュール
* [DBI](http://search.cpan.org/~timb/DBI/DBI.pm)
  * DriverですべてのRDBMSの差を吸収して統一的なインターフェイスを提供する
  * (DBD::*) MySQL、PostgreSQL、SQLite、…
* はてなではMySQLを採用

## DBI を用いる

* PerlでRDBMSとやり取りする最も素朴な方法 (最も高速)
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

* Slice に `{}` を指定すると各レコードがハッシュリファレンスで返る
* メソッド名がわかりづらい

``` perl
# ↓も等価
my $artists = $dbh->selectall_arrayref(q[
    SELECT * FROM artist
    WHERE birthday < ?
    ORDER BY birthday ASC
], { Slice => {} }, '2008-01-01');
```

## DBIと組み合わせて使うモジュール

* [DBIx::Sunny](http://search.cpan.org/~kazeburo/DBIx-Sunny/lib/DBIx/Sunny.pm)
  * DBIよりわかりやすいインターフェイスを提供する
* [SQL::NamedPlaceholder](http://search.cpan.org/~satoh/SQL-NamedPlaceholder/lib/SQL/NamedPlaceholder.pm)
  * プレースホルダに名前をつけることができる
* はてなでは以下のようなことを自動で行なうクラスを作って使っています
  * 覚える必要はありません

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

$rows = [ map { Vocaloid::Model::Artist->new($_) } @$rows ];
```

## DBIx::Sunnyを使った独自拡張

* はてなではDBIx::Sunnyを使ってさらにメソッドを増やしたものを使っています
* DBIx::Sunny + Modelオブジェクト化

<!--
ここに出てくる *_as 系のメソッドはDBIx::Sunnyにはありません。
しかし、2011年以降のはてなのプロダクトではこのような拡張がされています。
今日の課題 (Intern-Diary) でも同じ拡張を使います。
-->

### 条件に合う一行を取得 `select_row_as`

``` perl
my $artist = $dbh->select_row_as(q[
    SELECT * FROM artist
    WHERE name = :name
    LIMIT 1
], +{
    name => '初音ミク',
}, 'Vocaloid::Model::Artist');

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

### 条件に合う行を複数取得 `select_all_as`

``` perl
my $artists = $dbh->select_all_as(q[
    SELECT * FROM artist
      WHERE
        name LIKE :name
      ORDER BY id ASC
      LIMIT :limit
      OFFSET :offset
], +{
    name   => '鏡音%',
    limit  => 10,
    offset => 0,
}, 'Vocaloid::Model::Artist');

for my $artist (@$artists) {
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

### 行の挿入 `query`

``` perl
$dbh->query(q[
    INSERT INTO artist
      SET
        id       = :id,
        name     = :name,
        birthday = :birthday
], +{
    id       => 5,
    name     => '重音テト',
    birthday => '2008-04-02',
});
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

### 行の更新

``` perl
$dbh->query(q[
    UPDATE artist
      SET
        name = :name
      WHERE
        id = :id
], +{
    name => '弱音ハク',
    id   => 1,
});
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

### 行の削除

``` perl
$dbh->query(q[
    DELETE FROM artist
      WHERE
        id = :id
], +{
    id => 1,
});
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

## Model クラスの役割

* データをクラスに紐付ける
* 内部情報で完結するメソッドを持たせる
* **ここからデータベースへアクセスするべきではない**

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

## セキュリティ

* データベースの脆弱性は致命的
* データの漏洩、損失
* 気をつけましょう

### 悪い例

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

### 気をつけるべきこと

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

### 大まかな機能

* ユーザは URL (エントリ) を個人のブックマークに追加し、コメントを残せる
* エントリはユーザに共通の情報を持つ (ページタイトルなど)
* とりあえず一人用で (マルチユーザも視野にいれつつ)

### add, list, delete

3 操作くらいできるようにしてみたい

* bookmark.pl add &lt;<var>url</var>&gt; [コメント]
  * ブックマークを追加


``` text
$ ./bookmark.pl add http://www.yahoo.co.jp/ ヤッホー
Bookmarked [8] Yahoo! JAPAN <http://www.yahoo.co.jp/>
    @2011-08-16 ヤッホー
```

* bookmark.pl list
  * ブックマークの一覧を出力


``` text
$ ./bookmark.pl
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

* bookmark.pl delete &lt;<var>url</var>&gt;
  * ブックマークを削除


``` text
$ ./bookmark.pl delete http://www.google.com/
Deleted
```

## …という bookmark.pl を作ってみよう

コードを手元に

``` text
$ git clone https://github.com/hatena/Intern-Bookmark-2013.git
$ cd Intern-Bookmark-2013
$ git submodule update --init
$ script/setup.sh
```

以降こんな感じでいきます

1. スキーマの設計
1. Service層とModelの設計
1. bookmark.pl
1. アプリケーションのロジックを書く

## スキーマの設計

* どんな概念が登場するか？
  * `user`
  * `entry`
  * `bookmark`
* 何が一意であるべきか

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

###  bookmark

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

## Service層とModelの設計

###  コードの設計

* データをモデルに紐付ける
* データ操作をServiceとして集約
  * DBへのアクセスが散らばらない
  * テストを書きやすい
    * Modelが独立しているためデータと関係なくインスタンス化できる

### 重要

* Service層: データベースとのやり取り
* Model層: データを利用しやすい形に

## どんなクエリが必要ですか

* ユーザのブックマーク一覧を取得
  * `SELECT * FROM bookmark WHERE user_id = ...`
* ブックマークを追加する
  * `INSERT INTO bookmark ...`
* ブックマークを削除する
  * `DELETE FROM bookmark WHERE id = ...`
* それぞれメソッドを作る

``` perl
# ブックマーク一覧
my $bookmarks = Intern::Bookmark::Service::Bookmark->find_bookmarks_by_user($db, +{
    user => $user,
});

# ブックマーク追加
Intern::Bookmark::Service::Bookmark->add_bookmark($db, +{
    user    => $user,
    url     => $url,
    comment => $comment,
});

# ブックマーク削除
Intern::Bookmark::Service::Bookmark->delete_bookmark_by_url($db, +{
    user => $user,
    url  => $url,
});
```

* いきなり実装を書くのは難しい？
  * 案1: とりあえずテストを書いてみる
  * 案2: とりあえず一番外側のスクリプトを書いてみる
* 試しながら少しずつ実装する

## bookmark.plからの利用

* **bookmark.pl は最小限の処理に**
* アプリケーションのロジックはModelクラスとServiceクラスに集約
* コマンドライン周りの処理だけ記述

```perl
#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

use FindBin;
use lib "$FindBin::Bin/lib";
use Pod::Usage; # for pod2usage()
use Encode;
use Encode::Locale;

use Intern::Bookmark::Config;
use Intern::Bookmark::DBI::Factory;
use Intern::Bookmark::Service::Bookmark;
use Intern::Bookmark::Service::User;

binmode STDOUT, ':encoding(console_out)';

my %HANDLERS = (
    add    => \&add_bookmark,
    list   => \&list_bookmarks,
);

my $command = shift @ARGV || 'list';

$ENV{INTERN_BOOKMARK_ENV} = 'local';
my $db = Intern::Bookmark::DBI::Factory->new;

my $name = $ENV{USER};
my $user = Intern::Bookmark::Service::User->find_user_by_name($db, +{ name => $name });
unless ($user) {
    Intern::Bookmark::Service::User->create($db, +{ name => $name });
    $user = Intern::Bookmark::Service::User->find_user_by_name($db, +{ name => $name });
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

    print 'Bookmarked ' . bookmark_to_string($bookmark);
}

sub list_bookmarks {
    my ($user) = @_;

    printf "*** %s's Bookmarks ***\\n", $user->name;

    my $bookmarks = Intern::Bookmark::Service::Bookmark->find_bookmarks_by_user($db, +{
        user => $user,
    });
    $bookmarks = Intern::Bookmark::Service::Bookmark->load_entry_info($db, $bookmarks);

    foreach my $bookmark (@$bookmarks) {
        print bookmark_to_string($bookmark);
    }
}

sub bookmark_to_string {
    my ($bookmark) = @_;
    return sprintf("[%d] %s <%s>\\n    @%s %s\\n", $bookmark->bookmark_id, $bookmark->entry->title, $bookmark->entry->url, $bookmark->created, $bookmark->comment);
}
```

## 各Modelクラス

* `select_row_as` などで指定するためのクラス
* 各テーブルに一つModelクラスを作る
* **ここからデータベースへアクセスするべきではない**
* 作成日時 (`created`) をDateTimeオブジェクトに変換したり

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

## Serviceにロジックを実装

* ここが一番楽しいところですね！

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

* croak
  * use [Carp](http://search.cpan.org/~zefram/Carp/lib/Carp.pm) すると使えます
  * die と似てるけど呼び出し元で死ぬ

## テスト

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
use String::Random qw(random_regex);
use Test::Deep;
use Test::Exception;
use Test::Intern::Bookmark;
use Intern::Bookmark::DBI::Factory;

...

sub add_bookmark : Test(4) {
    my ($self) = @_;
    
    # 登場人物を作成
    my $user = create_user;
    my $url = 'http://' . random_regex('\w{15}') . '.com/';

    my $db = Intern::Bookmark::DBI::Factory->new;

    # テストしたいメソッドを実行
    my $bookmark = Intern::Bookmark::Service::Bookmark->add_bookmark($db, {
        user    => $user,
        url     => $url,
        comment => 'Comment',
    });

    # 結果を確認
    ok $bookmark;
    is $bookmark->user_id, $user->user_id;
    is $bookmark->entry->url, $url;
    is $bookmark->comment, 'Comment';
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
use lib file(__FILE__)->dir->parent->parent->parent->parent->subdir('lib')->stringify;

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

    my ($package, $file) = caller;
    # 先に読み込むべきモジュールを先に記述する
    # -common は暗黙的に読み込まれる
    my @options = (
        -common => qq[
            use Test::More;
            use Test::Exception;
            use Test::Differences;
            use Test::Time;
            use Test::Intern::Bookmark::Factory;

            use encoding 'utf8';
            binmode Test::More->builder->output, ":utf8";
            binmode Test::More->builder->failure_output, ":utf8";
            binmode Test::More->builder->todo_output, ":utf8";

            use parent 'Test::Class';
            END {
                $package->runtests if \$0 eq "\Q$file\E";
            }
        ],
        -mech => qq[
            use HTTP::Status qw(:constants);
            use Test::Intern::Bookmark::Mechanize;
        ],
    );

    my %specified = map { $_ => 1 } -common, @_;

    my $code = '';
    while (my ($option, $fragment) = splice @options, 0, 2) {
        $code .= $fragment if delete $specified{$option};
    }
    die 'Invalid options: ' . join ', ', keys %specified if %specified;

    eval "package $package; $code";
    die $@ if $@;
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
├── bookmark.pl
├── db
│   └── schema.sql
├── lib
│   └── Intern
│       ├── Bookmark
│       │   ├── Config.pm
│       │   ├── DBI
│       │   │   └── Factory.pm
│       │   ├── DBI.pm
│       │   └── Error.pm
│       └── Bookmark.pm
└── t
    ├── lib
    │   └── Test
    │       └── Intern
    │           └── Bookmark.pm
    ├── model
    │   ├── bookmark.t
    │   ├── entry.t
    │   └── user.t
    ├── object
    │   ├── config.t
    │   ├── dbi-factory.t
    │   ├── dbi.t
    │   └── util.t
    └── service
        ├── bookmark.t
        ├── entry.t
        └── user.t
```

## 以上

*  試行錯誤しつつ、わからないところは早めに人に聞きましょう

## 課題: diary.pl

<a href="http://d.hatena.ne.jp/keyword/%C6%FC%CB%DC%BF%CD%A4%CB%A4%CF%A5%D6%A5%ED%A5%B0%A4%E8%A4%EA%C6%FC%B5%AD" target="_blank">日本人にはブログより日記 - はてなキーワード</a>

* コマンドラインインターフェースで日記を書けるツール diary.pl を作成してください (必須)
* diary.pl に機能を追加してください (記事のカテゴリ機能など)

### 基本機能

*  記事の追加
*  記事の一覧表示
*  記事の編集
*  記事の削除
*  マルチユーザー (ただし今回はシングルユーザーでしか利用しない)

### 実行例

``` text
$ ./diary.pl add タイトル  # 記事追加
$ ./diary.pl list         # 記事を一覧
$ ./diary.pl edit 記事ID   # 記事を編集
$ ./diary.pl delete 記事ID # 記事を削除
```

### スキーマ設計

<!--
編集者ノート: テーブルのヒントを与えるとスキーマ設計の創造性を奪うので敢えて明記しないようにしました。 by nitro_idiot
-->

* 望むように独自のスキーマを設計してよいです
* データベース名は `intern_diary` としてください
  * テスト用のDBは `intern_diary_test`
  * いずれも `script/setup.sh` で作られるはずです

## オプション課題 独自機能

* アプリケーションに独自の機能を追加してみてください
  * 記事のカテゴリ分け機能
    * ヒント: 多対多リレーションの活用
  * 検索
    * ヒント: `LIKE`演算子
  * などなど

## 評価基準

* 基本機能 5点 (必須)
  * 記事の追加・一覧 3点
  * 記事の編集・削除 2点
* スキーマ設計 2点
  * パフォーマンス・セキュリティに留意しているか
* 追加機能 2点
* テスト 1点

## mysqldump お願い

評価のため mysqldump もお願いします。

保存先は mysqldump ディレクトリに

``` text
$ mkdir mysqldump
$ mysqldump -uroot -Q intern_diary > mysqldump/intern_diary.sql
```

これも commit, push してください。

## 今日書くコードは明日以降も利用します！

*  CLI 以外の利用も見据えた設計を
*  アプリケーションに必要な機能は Model および Service クラス内に書きましょう

## 講義はここまでです

* 分からないことはメンターか隣りのインターンに尋ねましょう
* 人気の質問に関してはあとでまとめて補足をするかもしれないのでどんどん訊いてください

##  補足編

### コマンドラインに関すること

* <code>@ARGV</code> 変数
  * ./diary.pl hoge fuga として起動すると <code>@ARGV = ('hoge', 'fuga')</code> となります
* コマンドライン引数をパーズするには [Getopt::Long](http://search.cpan.org/~jv/Getopt-Long/lib/Getopt/Long.pm)
* 標準入力からの読み取り

``` perl
my $data = join "\\n", <STDIN>;
```

### ALTER TABLE

* CREATE TABLE した後にスキーマの変更がしたくなったら
* ALTER TABLEを使いましょう

```sql
ALTER TABLE entry
  ADD COLUMN updated TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00' AFTER `created`;
```

- ref [MySQL 5.5 Reference Manual :: 13.1.7 ALTER TABLE Syntax](http://dev.mysql.com/doc/refman/5.5/en/alter-table.html)

### SHOW CREATE TABLE

* `SHOW CREATE TABLE entry;` などすると、そのテーブルを作成する`CREATE TABLE`文が見られる

### EXPLAIN

* `EXPLAIN SELECT * FROM...` などすると、インデックスが利くか、走査がされる行数などがわかります

### 開発のお供に

* [Devel::KYTProf](http://search.cpan.org/~onishi/Devel-KYTProf/lib/Devel/KYTProf.pm) を使うのがオススメ
  * use するだけ

```text
$ perl -MDevel::KYTProf ./bookmark.pl add http://www.hatena.ne.jp/ はて ー
   23.423 ms  [DBI]  connect dbi:mysql:dbname=intern_bookmark;host=localhost  | Try::Tiny:76
    0.221 ms  [Intern::Bookmark::DBI::st]  SELECT * FROM user WHERE name = ? /* /Users/cockscomb/Hatena/Intern-Bookmark/lib/Intern/Bookmark/Service/User.pm line 15 */ (bind: cockscomb) (1 rows)  | DBD::_::db:1628
    0.698 ms  [DBI]  connect dbi:mysql:dbname=intern_bookmark;host=localhost  | Try::Tiny:76
    0.173 ms  [Intern::Bookmark::DBI::st]  SELECT * FROM entry WHERE url = ? /* /Users/cockscomb/Hatena/Intern-Bookmark/lib/Intern/Bookmark/Service/Entry.pm line 18 */ (bind: http://www.hatena.ne.jp/) (0 rows)  | DBD::_::db:1628
  266.015 ms  [LWP::UserAgent]  GET http://www.hatena.ne.jp/  | Intern::Bookmark::Service::Entry:93
    0.829 ms  [DBI]  connect dbi:mysql:dbname=intern_bookmark;host=localhost  | Try::Tiny:76
    0.542 ms  [Intern::Bookmark::DBI::st]  INSERT INTO entry SET url     = ?, title   = ?, created = ?, updated = ? /* /Users/cockscomb/Hatena/Intern-Bookmark/lib/Intern/Bookmark/Service/Entry.pm line 58 */ (bind: http://www.hatena.ne.jp/, はてな, 2013-03-13T02:55:56, 2013-03-13T02:55:56) (1 rows)  | Intern::Bookmark::DBI::db:64
    0.436 ms  [DBI]  connect dbi:mysql:dbname=intern_bookmark;host=localhost  | Try::Tiny:76
    0.164 ms  [Intern::Bookmark::DBI::st]  SELECT * FROM entry WHERE url = ? /* /Users/cockscomb/Hatena/Intern-Bookmark/lib/Intern/Bookmark/Service/Entry.pm line 18 */ (bind: http://www.hatena.ne.jp/) (1 rows)  | DBD::_::db:1628
    0.402 ms  [DBI]  connect dbi:mysql:dbname=intern_bookmark;host=localhost  | Try::Tiny:76
    0.129 ms  [Intern::Bookmark::DBI::st]  SELECT * FROM bookmark WHERE user_id  = ? AND entry_id = ? /* /Users/cockscomb/Hatena/Intern-Bookmark/lib/Intern/Bookmark/Service/Bookmark.pm line 18 */ (bind: 1, 5) (0 rows)  | DBD::_::db:1628
    0.462 ms  [DBI]  connect dbi:mysql:dbname=intern_bookmark;host=localhost  | Try::Tiny:76
    0.398 ms  [Intern::Bookmark::DBI::st]  INSERT INTO bookmark SET user_id  = ?, entry_id = ?, comment  = ?, created  = ?, updated  = ? /* /Users/cockscomb/Hatena/Intern-Bookmark/lib/Intern/Bookmark/Service/Bookmark.pm line 95 */ (bind: 1, 5, はてー, 2013-03-13T02:55:56, 2013-03-13T02:55:56) (1 rows)  | Intern::Bookmark::DBI::db:64
    0.456 ms  [DBI]  connect dbi:mysql:dbname=intern_bookmark;host=localhost  | Try::Tiny:76
    0.158 ms  [Intern::Bookmark::DBI::st]  SELECT * FROM bookmark WHERE user_id  = ? AND entry_id = ? /* /Users/cockscomb/Hatena/Intern-Bookmark/lib/Intern/Bookmark/Service/Bookmark.pm line 18 */ (bind: 1, 5) (1 rows)  | DBD::_::db:1628
    0.383 ms  [DBI]  connect dbi:mysql:dbname=intern_bookmark;host=localhost  | Try::Tiny:76
    0.116 ms  [Intern::Bookmark::DBI::st]  SELECT * FROM entry WHERE entry_id IN (?) /* /Users/cockscomb/Hatena/Intern-Bookmark/lib/Intern/Bookmark/Service/Entry.pm line 32 */ (bind: 5) (1 rows)  | DBIx::Sunny::db:145
Bookmarked [5] はてな <http://www.hatena.ne.jp/>
    @2013-03-13 02:55:56 はてー
```

*  それから… [Data::Dumper](http://search.cpan.org/~smueller/Data-Dumper/Dumper.pm) いいです

``` perl
use Data::Dumper;
my $x = { foo => [1,2,3] };
print Dumper($x);
# $VAR1 = {
#           'foo' => [
#                      1,
#                      2,
#                      3
#                    ]
#         };
```

* repl もいいですね ([Eval::WithLexicals](http://search.cpan.org/~dgl/Eval-WithLexicals/lib/Eval/WithLexicals.pm))

###  byte string & utf8 string

<a href="http://search.cpan.org/~nwclark/perl-5.8.8/lib/utf8.pm">perldoc utf8</a>, <a href="http://search.cpan.org/~nwclark/perl-5.8.8/pod/perlunicode.pod">perlunicode</a>

*  Perl の文字列にはバイト列 (byte string) と文字列 (utf8 character string) の2種類がある
*  バイト列は 0x00-0xFF のバイトの並びを表す
*  文字列は U 0000～U-FFFFFFFF (32ビット環境の場合) の文字の並びを表す
  *  一般的な計算機では UTF-8 で符号化されているので utf8 文字列と呼ばれる
*  バイト列と区別するとき、文字列のことを「(utf8) フラグが立っている」という


``` perl
# 何もしないとバイト列になる (ファイルが UTF-8 なら、UTF-8 を表すバイト列になる)
$bytes = 'あいうえお';
warn length $bytes; # 15

# use utf8; プラグマの効力が及ぶ範囲では文字列になる (ファイルは UTF-8 にしておく)
use utf8;
$chars = 'あいうえお';
warn length $chars; # 5
```

###  byte/character convertion

[Encode](http://search.cpan.org/~dankogai/Encode/Encode.pm)

*  入出力は基本的にバイト列になっている
  *  ファイル、DB、HTTP、...
*  Perl で文字の列を扱いたいときは原則として utf8 文字列を使うべき
  *  → 入力はできるだけ早い段階で文字列に変換し、出力はできるだけ遅い段階でバイト列に変換する
  *  バイト列を扱いたいときは例外
*  バイト列と文字列の相互変換には Encode モジュールを使う
  *  encode/decode はどちらがどちらか覚えにくいけど、
    *  人間が読める文字列を機械が読めるバイト列にするのが符号化 (encode)
    *  機械が読めるバイト列を人間が読める文字列にするのが復号 (decode)


``` perl
use Encode;

$bytes = encode 'utf8', $chars # 文字列を符号化してバイト列に
$chars = decode 'utf8', $bytes # バイト列を復号して文字列に
```

###  DateTime

[DateTime](http://search.cpan.org/~drolsky/DateTime/lib/DateTime.pm), [DateTime::Format::MySQL](http://search.cpan.org/~drolsky/DateTime-Format-MySQL/lib/DateTime/Format/MySQL.pm)

*  Perl で日時を表すときは DateTime がよく使われる


``` perl
$dt = DateTime->now(time_zone => 'UTC');
$dt = DateTime->new(year => 2010, month => 8, day => 3, hour => 10, minute => 0, second => 0, time_zone => 'UTC');

$dt->add(days => 3);
$dt->subtract(hours => 4);

warn $dt->ymd('-');
warn $dt->hms(':');
```

*  データベースでは UTC (協定世界時) で保存し、表示するときに必要ならタイムゾーン変換するのが好ましい


``` perl
warn $dt->time_zone;
$dt->set_time_zone('Asia/Tokyo');
```

*  MySQL 形式との変換には DateTime::Format::MySQL を使う


``` perl
use DateTime::Format::MySQL;

my $dt = DateTime::Format::MySQL->parse_datetime('2010-01-01 02:02:02');
warn DateTime::Format::MySQL->format_datetime($dt);
```

*  なお、本当の Perl ネイティブの時刻形式は time 関数の形式
  *  ほとんどの環境では Unix の time_t = 1970年1月1日0時0分0秒 (UTC) からの秒数


``` perl
$time = time;
warn $time;

use DateTime;
$dt = DateTime->from_epoch(epoch => $time);
warn $dt->epoch;
```

###  Config.pm

* DB の接続情報を設定
* dbi:mysql:dbname=intern_diary
  * MySQL の intern_diary データベースに接続
* このクラスはいろいろな設定を持つ
* 環境変数で設定を切り替えられる
  * `./diary.pl -E local`


``` perl
package Intern::Diary::Config;
use strict;
use warnings;
use utf8;

use Config::ENV 'INTERN_DIARY_ENV', export => 'config';
use Path::Class qw(file);

common {
};

config default => {
};

config local => {
    parent('default'),
    db => {
        intern_diary => {
            user     => 'nobody',
            password => 'nobody',
            dsn      => 'dbi:mysql:dbname=intern_diary;host=localhost',
        },
    },
    db_timezone => 'UTC',
};

1;
```

## 参考リンク

* [MySQL 5.5 Reference Manual](http://dev.mysql.com/doc/refman/5.5/en/)
* [MySQL 5.5 Reference Manual :: 13 SQL Statement Syntax](http://dev.mysql.com/doc/refman/5.5/en/sql-syntax.html)
* [DBI - search.cpan.org](http://search.cpan.org/~timb/DBI-1.628/DBI.pm)
* [DBIx::Sunny - search.cpan.org](http://search.cpan.org/~kazeburo/DBIx-Sunny-0.21/lib/DBIx/Sunny.pm)

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/2.1/jp/"><img alt="クリエイティブ・コモンズ・ライセンス" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/2.1/jp/88x31.png" /></a><br />この 作品 は <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/2.1/jp/">クリエイティブ・コモンズ 表示 - 非営利 - 継承 2.1 日本 ライセンスの下に提供されています。</a>
