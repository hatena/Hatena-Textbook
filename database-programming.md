# データベースの基礎

* 言語の基礎
* <strong>データベース操作 ← いまここ</strong>
* WAF によるウェブアプリケーション開発
* JavaScript で学ぶイベントドリブン
* 自由課題

## アンケート

* SQL書いたことある
* プログラミング言語から使ったことある

## 今日の講義

* 基本編
  * データベースの基本的な概念や使い方を紹介します
* 実践編
  * Perl/ScalaでMySQLにアクセスする方法を学ぶ
  * RDBMSを使った簡単なブックマーク管理ツールの作り方をなぞります
* 課題の解説

## ご注意

* 駆け足で進みますのでがんばってついてきてください
* 質問があれば途中でも聞いてください
  * わからないところをメモっておいて後で聞くのも良いです

## データベースとは

* データ (data) とは
  * = コンピュータで取り扱う情報
* データベース (database) とは
  * = データを集めて取り扱いやすくしたもの

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

* ユーザページ: 過去の書き込みを一覧できるように
  * → dat ファイルにユーザ名を記録して、一覧するときに全部検索？
* 耐障害性: マシンが一台故障してもサービスが継続できるように
  * → dat ファイルを複数のマシンにコピーする？


## ウェブサービスのデータは増え続けます

* データは大量・増える一方
* アクセスも増える一方
* サービスは 24 時間 365 日提供したい
* データは消えてはならない

* 昨日作ったdiary-file.plを思い出してみよう

##  そのための データベース管理 です

* データベース管理システム (DataBase Management System = DBMS)

* **データの抽象化**
  * データがディスクにどのように格納されているかを意識する必要はない
* **効率が良い**
  * 用途に合わせて最適な構造でデータを記録できる
* **並列アクセス可能に**
  * トランザクション・ロック機構がある
  * 並列にアクセスするアプリでも、利用するときは一つの接続のみを考えていれば良い
* **クラッシュ時復帰** (データ損失を防ぐ)
  * 停電などによりサーバが死ぬとか起こりえる
  * ファイルシステムにそのまま記録する場合、書込み中だと書き込もうとした内容が中途半端だったり、消失したりすることが起こりえる

## いろんなDBMS知ってますか?

* [リレーショナルDBMS](http://ja.wikipedia.org/wiki/%E9%96%A2%E4%BF%82%E3%83%87%E3%83%BC%E3%82%BF%E3%83%99%E3%83%BC%E3%82%B9%E7%AE%A1%E7%90%86%E3%82%B7%E3%82%B9%E3%83%86%E3%83%A0)
  * MySQL / PostgreSQL / SQLite
  * <a href="http://www.postgresql.org/files/postgresql.mp3" target="_blank">http://www.postgresql.org/files/postgresql.mp3</a>
* カラム指向DBMS
  * BigTable / Apache Cassandra / Apache HBase
* [ドキュメント指向DBMS](http://ja.wikipedia.org/wiki/Category:%E3%83%89%E3%82%AD%E3%83%A5%E3%83%A1%E3%83%B3%E3%83%88%E6%8C%87%E5%90%91%E3%83%87%E3%83%BC%E3%82%BF%E3%83%99%E3%83%BC%E3%82%B9)
  * MongoDB / Apache CouchDB / Elasticsearch
* グラフDBMS
  * Neo4j
* キーバリューストア
  * Memcached/Redis/Riak

## 関係データベース

* もっとも広く使われているデータベースの一種
* 関係モデルに基づいたデータベースシステム
  * MySQL/PostgreSQL/Oracle

![MySQL](http://blog.trippyboy.com/wp-content/uploads/2014/01/logomysql.gif)


##  関係モデル

* 関係モデルとは
  * データを関係として表現し取り扱うモデル

* 関係とは?
  * 属性を持った組 (タプル) の集合で表される

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

* 関係には和、差、直積、射影、結合などの演算を数学的に定義できる
* 関係はわかりやすさのために「テーブル (表)」と呼ばれる

<!--
これは定義的な説明なので、軽く流して良い
-->

##  関係モデルに基づいたデータベース

* = RDBMS
* データベース は複数の「テーブル (表)」を持つ = 関係
* データは「レコード (列)」で表される = 組
  * レコードは「カラム (属性) 」を持つ
* SQL と呼ばれる言語に基づいて、テーブルを定義したりテーブルに対して演算を行うことができる

## 関係データベースにおけるテーブル

表とレコードとカラム


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

## SQL
* 関係データベースに問い合わせを行うための言語
* SQLは標準化されており、ほとんどのRDBMSで使うことができる
  * データの定義
  * データの作成/読込/更新/削除

## SQLで関係を定義する

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
* 使いこなせると便利!
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
* ACID特性をもつ
  * 原子性 atomicity
  * 一貫性 consistency
  * 独立性 isolation
  * 耐久性 durability

### 例: 銀行の送金システム
  1. 元口座から1,000円引く
  1. 送金先の口座に1,000円足す
* いずれかが失敗するとデータに不整合が生じる
* 同時に送金されたときに正しく動く?

## 〜〜〜 ここまで基礎知識 〜〜〜

<!--
インターン期間中ははてなの社員と同等のことを求められる場面も多いと思います
今までの知識を前提として、いかに良いコードを書けるか、を気にしてください
-->

* 応用編
  * より良いスキーマ設計
  * パフォーマンス
  * インデックス

## より良いスキーマ設計をするために

## カラムのデータ型

* カラムのデータ型、特に数値型は桁あふれに気をつけること
* MySQL 5.5の場合
  * INT: -2147483648 〜 2147483647
  * 21億レコードは意外とすぐに到達します
  * `id`は`BIGINT UNSIGNED`にしておくのが安全
    * 18446744073709551615 (1844京)
* ref [MySQL 5.5 Reference Manual :: 11 Data Types](http://dev.mysql.com/doc/refman/5.5/en/data-types.html)

## 制約

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

## PRIMARY KEY

* テーブル内でレコードを一意に識別することができるカラム (任意)
  * 他のレコードと被ってはいけない (UNIQUE制約)
  * 値がなければいけない (NOT NULL制約)
* テーブルに1つだけ設定できる
* 「インデックス」(後述) として使える
* 「id」という名前


## テーブル間のリレーション

## 一対多のリレーション

<div style="text-align: center; background: #fff"><img src="http://cdn-ak.f.st-hatena.com/images/fotolife/n/nitro_idiot/20130812/20130812003717.png"></div>

* このスキーマでは`album`と`artist`は「一対多」
  * 一つの`album`に一人の`artist`しか対応づけられない
  * 一人の`artist`は複数の`album`を作れる

## 多対多のリレーション

<div style="text-align: center; background: #fff"><img src="http://cdn-ak.f.st-hatena.com/images/fotolife/n/nitro_idiot/20130812/20130812003716.png"></div>

* オムニバス形式の`album`を登録するには？

## album_artist_relationテーブル

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

* RDBMSはスケールがしずらい
  * 複数のサーバ間で一貫性と可用性を保つためデータを分散させにくい
  * ヒント: CAP定理
* アプリケーションサーバはスケールしやすい
  * マシンリソースが必要な処理はアプリケーションサーバでやるほうが良い

## 推測するな計測せよ

* 勘で対処してはいけない
  * 無意味に複雑になるだけに終わる
* 問題が起こったときに計測し、ボトルネックを潰そう
* EXPLAIN文を使う


``` sql
EXPLAIN SELECT album.name
FROM album LEFT JOIN artist ON album.artist_id = artist.id
WHERE artist.name = '初音ミク';
```

## パフォーマンス対策

* クエリ数に気をつける
  * ワンクエリで取れるところはワンクエリで
    * ループ内でクエリ投げるとかやりがち
* 不要なクエリは投げない
* 遅くなりがちなクエリに気をつける
  * インデックス使ってない
  * 無茶なJOIN
  * 無茶なサブクエリ

<!--
JOINやサブクエリはデータ量が多いとテンポラリ領域を使うため極端に遅くなる。
件数が多い場合はアプリケーション側で連結処理を書くほうが良い。
一般的にはWebアプリケーションで使われない。
ただし、バッチ処理などで使われることがある。
-->


## インデックス

* カラムの組み合わせについてインデックス (索引) を作成することができる

* Bツリーがよく使われる
* 計算量
  * インデックスがない: O(n)
  * インデックスあり: O(log n)


<!--
インデックスは複数指定することができます。そういうインデックスを複合インデックスと呼びます。
-->
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

## インデックスのデメリット

* インデックスを張ると、更新・削除時にオーバーヘッドがある
* 一般的なアプリケーションでは 参照処理 ＞ 更新処理 なのであまり問題にならない

## 語られなかったこと

* サブクエリ
* DISTINCT
* UNION句
* 外部キー (Foreign Key) 制約
* TRIGGER
* DBMSのユーザ管理と権限

## mysqlコマンドの使い方

### インタラクティブシェルを使う

データベースに対して直接SQLを実行したい場合は以下のようmysqlコマンドのインタラクティブシェルを使うと便利です。

```sh
$ mysql -unobody -pnobody intern_diary_$USER # mysqlのインタラクティブシェルに入る
mysql> show tables; # 定義されているテーブル一覧をみる
mysql> describe users; # usersテーブルの定義を調べる
mysql> show create table users; # usersテーブルを定義しているSQLを表示する
mysql> SELECT * FROM users LIMIT 10; # SQLを実行する(SELECT)
mysql> INSERT INTO users (id, name) VALUES (0, "tarou"); # SQLを実行する(INSERT)
mysql> CREATE TABLE user ( # 複数行のSQLをペーストしてまとめて実行することもできます
    ->   id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    ->   name VARCHAR(32) NOT NULL
    -> );
```

### ファイルに書かれたSQLを読み込んで実行する

`db/schema.sql`に書かれたSQLを一度に読み込みたいときに利用すると便利です。

```sh
$ cat db/schema.sql | mysql -unobody -pnobody intern_diary_$USER
```

## 参考リンク

* [MySQL 5.5 Reference Manual](http://dev.mysql.com/doc/refman/5.5/en/)
* [MySQL 5.5 Reference Manual :: 13 SQL Statement Syntax](http://dev.mysql.com/doc/refman/5.5/en/sql-syntax.html)

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/2.1/jp/"><img alt="クリエイティブ・コモンズ・ライセンス" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/2.1/jp/88x31.png" /></a><br />この 作品 は <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/2.1/jp/">クリエイティブ・コモンズ 表示 - 非営利 - 継承 2.1 日本 ライセンスの下に提供されています。</a>
