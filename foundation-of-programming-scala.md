
# Scalaによるプログラミングの基礎

## 事前課題
[https://github.com/hatena/Hatena-Intern-Exercise2015/tree/master/scala](https://github.com/hatena/Hatena-Intern-Exercise2015/tree/master/scala)

## Scala 参考文献
##### 書籍
- Scalaスケーラブルプログラミング第2版 ([ISBN:4844330845](http://www.amazon.co.jp/dp/4844330845))
  - 内容はすこし古いけど、言語作者が書いた本で、まずはこれ
- Scala関数型デザイン&プログラミング([ISBN:4844337769](http://www.amazon.co.jp/dp/4844337769))
  - 関数型プログラミングの知見をまなびたければ
- Scala逆引きレシピ([ISBN:4798125415](http://www.amazon.co.jp/dp/4798125415))
  - はじめに読むのはおすすめしなけど、困った時に手元にあると助かる

##### ウェブリソース
- [A Tour of Scala](http://docs.scala-lang.org/tutorials/)
- [Effective-Scala](https://twitter.github.io/effectivescala/index-ja.html)
- [Scala API リファレンス](http://www.scala-lang.org/api/current/#package)
- [Scalaメモ(Hishidama's Scala Memo)](http://www.ne.jp/asahi/hishidama/home/tech/scala/)
  - とにかく網羅的なのでリファレンスがわりに
- [sbtチュートリアル](http://www.scala-sbt.org/0.13/tutorial/ja/)
- [scalatestのドキュメント](http://www.scalatest.org/user_guide/using_matchers)

---

## 準備

---

### 開発環境
- ライブラリはどうやっていれるの?
  - cpanfile/Gemfileみたいなのあるの?
- 自分で書いたコードのビルドはどうやるの?
- コンソールで軽く動かしてみたい

---

### 全部sbtでできる(まじか)

---

### インストール
- がんばってJDKをインストールしよう!
- そしてsbtをインストールしよう!

```sh
$ brew install sbt
```

- [sbtのチュートリアル](http://www.scala-sbt.org/0.13/tutorial/index.html)

---

### Hello, World

#### build.sbt

```sbt
name := "hello"

scalaVersion := "2.11.7"
```

#### Hello.scala

```scala
object Hello {
  def main(args: Array[String]) = println("Hi!")
}
```

---

### 実行

```sh
$ sbt
> run
[info] Compiling 1 Scala source to ...
[info] Running Hello
Hi!
[success] Total time: 27 s, completed 2014/09/13 11:37:35
>
```

- Scalaの処理系(jarファイル)がインストールされる

---

### jarファイル!! Javaだ！！

---

### jarファイル
- クラスファイルやリソースファイル(画像とか)が入ってるzipアーカイブ
- META情報も入っていて、どのクラスが実行できるとか書ける

---

### これで君もScalaが書ける!!
- sbt でconsoleを実行するとScalaのreplに入れる
- いろいろ試せて便利
- 電卓にも使えるぞ! (ただしJVMが起動するのが遅い)

```sh
$ sbt
> console
scala> 1 + 1
res0: Int = 2

scala>
```

---

## 準備完了

---

## Scala 紹介 その1

---


### 変数宣言 - var と val と if式

```scala
val x = 1 // 再代入できない
var y = 2 // 再代入できる

x = 5 // valだとエラーになる
y = 6 // varだと再代入できる
```

- 再代入できない変数を明示的に宣言できる!
- Perlでも変数を使いまわすと理解し難いコードができるので、やらない
  - ブログチームのコーディング規約でやめようって書いてある
- valって書いとくと再代入されてないことが確実なので安心
- var使うとレビューでめっちゃ怒られる

val はimmutableな変数定義
var mutableな変数定義
みたいな言い方をしたりする。

### if式

Scalaではvarを使うとレビューで怒られる（どうしても使わざるを得ない部分は除く）。
だいたいの変数はvalだけで事足りる。

Scalaは関数型言語のエッセンスを持つ言語のため、副作用を極力起こさないコードが書きやすくなっている。

条件に応じて変数の中身を決めたい場合

```scala
var result: String = ""

if (i % 3 == 0 && i % 5 == 0) {
  result = "FizzBuzz"
} else if (i % 3 == 0) {
  result = "Fizz"
} else if (i % 5 == 0) {
  result = "Buzz"
} else {
  result = i.toString
}
```

このように事前に変数を定義しておき、条件によって変数に値を再代入するのがよくあるパターン。
このパターンでも、Scalaだったらvalを使いたい。

Scalaのifは"if式"と呼ばれ、それ自体が結果を返す。

```scala
val result = if (i % 3 == 0 && i % 5 == 0) {
  "FizzBuzz"
} else if (i % 3 == 0) {
  "Fizz"
} else if (i % 5 == 0) {
  "Buzz"
} else {
  i.toString
}
```

これで`result`をvalで定義できる！

このようにScalaには変数の再代入を不要にするいろいろな仕組みがある。

---

## Scala 紹介 その2

---

### パターンマッチ!!

- めっちゃ便利なswitch文みたいなの
- 最近の言語だとだいたい入ってる

---

### 定数でマッチ

- match式を使う
- 式なので値を返すよ

```scala
val msg = x match {
  case 0 => "0だ!!"
  case 1 => "1だ!!"
  case _ => "それ以外だ!!"
}
println(msg)
```

---

### or にしたりifでガードしたり

```scala
val msg = x match {
  case 0 | 1        => "0か1や"
  case n if n < 100 => "100 以下やね"
  case _ => "それ以外だ!!"
}
println(msg)
```

---

### パターンマッチの力はこの程度ではない

あとででてくる

---

## Scala 紹介 その3

---

### コレクションが便利

- コレクションはいろいろついてくる
  - List/Array/Map/Set
  - 細かいのを数えるといろいろある
- コレクションには便利メソッドがめっちゃついてくる
  - map/filter/flatMap/find/findAll/reduce
  - take/drop/exists/sort/sortBy/zip/partition
  - grouped/groupBy
  - やまほどある

---

### List

```scala
val list = List(1,2,3,4,5,6,7,8,9) // こういう感じでリスト作れる
list.map { n => // 関数リテラル
  n * n
}.filter { n =>
  n % 2 == 0
}.sum
```

```scala
list.grouped(2).foreach { ns => println(ns) }
list.groupBy { n => if (n % 2 == 0) "even" else "odd" }
```

---

### 関数リテラル

```scala
list.reduce { (x, y) => // 引数リスト
  x * y  // 最後の式が返値
}
```

---

### Map
- Mapもだいたい他の言語でよくある普通な感じ
- 便利メソッドはいろいろ使える
- とりあえず紹介だけ

```scala
val urls = Map(
  "www"  -> "http://www.hatena.ne.jp",
  "b"    -> "http://b.hatena.ne.jp",
  "blog" -> "http://hatenablog.com"
)
urls.get("b") // → Some("http://b.hatena.ne.jp")
urls.get("v") // → None
```

---

### 突然の Some(x)! None!!

---

## Scala 紹介 その4

---

### Option型が便利!

### Option型とは

- あるかないかわからない値を表現できる型
- undefチェックするの忘れてた! というのがなくなるすぐれもの
- Option[+A]型
  - Some(x)という値
    - x は +A型の値 (Option[Int]型だったらInt型)
  - Noneという値
- Someの中身を使うには明示的に取り出す操作が必要

---

### Option型をつくる

- 値があるときはSomeに値をくるむ
- ないときはNone

```scala
Some("hello")
Some(1)
Some({ () => 5 * 3 })
None
```

---

### Option型に包まれた値を取り出す

```scala
val urls = Map(
  "www"  -> "http://www.hatena.ne.jp",
  "b"    -> "http://b.hatena.ne.jp",
  "blog" -> "http://hatenablog.com"
)

val bUrl = urls.get("b") // Some("http://b.hatena.ne.jp")
val vUrl = urls.get("v") // None

// 方法1 (bad)
bUrl.get // SomeかNoneか無視してとりだす/使ってたら怒られる
vUrl.get // ランタイムエラー!!

// 方法2
bUrl.getOrElse("no url") // Someだったら中身の値
vUrl.getOrElse("no url") // Noneだったらデフォルト値

// 方法3
bUrl match { // パターンマッチでそれぞれ処理する
  case Some(url) =>
    s"bのURLは $url ですぞ"
  case None =>
    "no url"
}
```

- getは使ったらアカン
- 特別な操作なしでは値が使えない
  - 値をちゃんと取り出したどうかは型でチェックされる

---

### パターンマッチ again
- 値の構造でマッチング
- Someの場合中身の値がurlにはいる!
- 対象が unapply メソッドを実装していると、こういうパターンマッチができる
  - case classというのを使うと簡単に作れる

```scala
val bUrl = Some("http://b.hatena.ne.jp")
bUrl match {
  case Some(url) =>
    s"bのURLは $url ですぞ"
  case None =>
    "no url"
}
```

---

### 不完全なパターンマッチ
- 必ずundefチェックできるとかいうけど、Noneのcase忘れるのでは

```scala
scala> bUrl match {
     |   case Some(url) =>
     |     s"url is $url"
     | }
<console>:10: warning: match may not be exhaustive.
It would fail on the following input: None
              bUrl match {
```

- コンパイラが警告出すぞ!

---

### Option型のいろんなメソッド

```scala
val bUrl = Some("http://b.hatena.ne.jp")

bUrl.filter { url => isHatenaUrl(url) } // trueならそのまま, falseならNoneになる
bUrl.exists { url => isHatenaUrl(url) } // Someなら条件式の結果, Noneならfalse
bUrl.map { url => getContent(url) }     // Someなら値を変換, Noneならそのまま
```

- 実はListに使えたメソッドは割りと使える
  - 要素数が0か1しか無いListだとみなせる

---

### 便利なflatMap

```scala
findEntryBy(entryId) // Option[Entry]
findUserBy(userId) // Option[User]
```

- entryのauthorを取得したい
- entryがSomeのときだけauthorを探して、authorが見つかったらSomeを返したい
- どちらかが見つからなかったらNone

```scala
findEntryBy(entryId).flatMap { entry =>
  findUserBy(entry.authorId)
}
```

- flatMapを使うとOptionを返すメソッドを次々と繋げられる
  - 全部がSomeだったときの処理が書ける
  - ただしネストしていくと読みづらい...
  - しかし読みやすくする技がある

```scala
findEntryBy(entryId).flatMap { entry =>
  findUserBy(entry.authorId).flatMap { user =>
    findUserOptionBy(user.id).flatMap { userOption =>
      findUserStatusBy(user.id).map { userStatus =>
        // 全部見つかった時の処理を書ける
        makeResult(entry, user, userOption, userStatus)
      }
    }
  }
}
```

---

## Scala 紹介 その5

---

### for 式が便利!

---

### シンプルなfor

```scala
for ( i <- (1 to 9) ) {
  println(i.toString)
}

for ( i <- (0 until 10) ) {
  println(i.toString)
}
```

- foreach メソッドが実装されてるとforのイテレーション対象にできる
  - 以下とほぼ一緒

```scala
(1 to 9).foreach { i =>
  println(i)
}
```

---

### 値を返すfor

```scala
val pows = for ( i <- (1 to 9) ) yield i * i
```

- map メソッドが実装されてるとyieldを使って値を生成できる
  - 以下とほぼ一緒

```scala
val pows = (1 to 9).map { i =>
  i * i
}
```

---

### ガードつきのfor

```scala
for ( i <- (1 to 9) if i % 2 == 0 ) {
  println(i.toString)
}
```

- filter メソッドが実装されてるとifでfilterできる
  - 以下とほぼ一緒
  - ※ 実際には withFilter メソッドが呼びだされる(参考: [Faq - How does yield work? - Scala Documentation](http://docs.scala-lang.org/tutorials/FAQ/yield.html#about-withfilter-and-strictness) )

```scala
(1 to 9).filter { i =>
  i % 2 == 0
}.foreach { i =>
  println(i.toString)
}
```

---

### 入れ子のfor

```scala
for (
  i <- (1 to 9);
  j <- (1 to 9)
) {
  print((i*j).toString + " ")
}
```

- foreachメソッドが実装されているとこうかける

```scala
(1 to 9).foreach { i =>
  (1 to 9).foreach { j =>
    print((i*j).toString + " ")
  }
}
```

---

### 値を生成する入れ子のfor

```scala
val kuku = for (
  i <- (1 to 9);
  j <- (1 to 9)
) yield i * j
```

- flatMapとmapが実装されているとこうかける

```scala
val kuku = (1 to 9).flatMap { i =>
  (1 to 9).map { j =>
    i * j
  }
}
```

- ならべるとflatMapをネストしてるのと一緒

```scala
val kukuku = for (
  i <- (1 to 9);
  j <- (1 to 9);
  k <- (1 to 9);
) yield i * j * k
```

```scala
val kukuku = (1 to 9).flatMap { i =>
  (1 to 9).flatMap { j =>
    (1 to 9).map { k =>
          i * j * k
    }
  }
}
```

- flatMapでどんどん処理をつなげていく... どこかで聞いたことがある..

---

### Option型をfor文で使う

- 以下のようにOptionを返す関数をflatMapでどんどん繋げられるんだった

```scala
val result = findEntryBy(entryId).flatMap { entry =>
  findUserBy(entry.authorId).flatMap { user =>
    findUserOptionBy(user.id).flatMap { userOption =>
      findUserStatusBy(user.id).map { userStatus =>
        // 全部見つかった時の処理を書ける
        makeResult(entry, user, userOption, userStatus)
      }
    }
  }
}
```

- つまりforを使うとこうかける!!

```scala
val result = for (
  entry      <- findEntryBy(entryId);
  user       <- findUserBy(entry.authorId);
  userOption <- findUserOptionBy(user.id);
  userStatus <- findUserStatusBy(user.id)
) yield makeResult(entry, user, userOption, userStatus)
```

- 読みやすい!
- 値が全部SomeならSome(makeResult(entry, user, userOption, userStatus))
- いずれかの値がNoneならNone

- for式を使うとある型の値のつなげて処理していくコードを綺麗に書ける
  - どうつなげられるかはflatMapの実装による
  - Option ならSomeのときは処理がつながるけどNoneならとまる

---

### モナド
- OptionやListはモナド
- モナドが要求する関数
  - return
      - 値をOptionやListに包む関数 => Some("hoge"), List(1,2,3)
  - bind
      - OptionやListを返す関数を組み合せる関数 => flatMap
  - これらがモナド則を満たすことが必要
- for式はHaskellのdo式に相当する
- OptionやList以外にも強力な抽象化メカニズムをモナドとして使えるぞ
- 詳しくは、<a href="http://www.amazon.co.jp/gp/product/4274068854">すごいHaskellたのしく学ぼう!</a> を読もう!
- [Scalaz](https://github.com/scalaz/scalaz)というのを使うとより強力なモナドや記法が使えるようになる
  - Haskellを使ったらよいのではってなるけど、あったら便利

---

## Scala 紹介 その6

---

### クラス定義が便利!

---

### classの定義

```scala
class Cat(n: String) { // コンストラクタ
  val name = n // フィールド

  def say(msg: String) : String = {
    name + ": " + msg + "ですにゃ"
  }
}
println( new Cat("たま").say("こんにちは") )

class Tiger(n: String) extends Cat(n) { // 継承
  override def say(msg: String) : String = { // オーバーライド
    name + ": " + msg + "だがおー"
  }
}
println( new Tiger("とら").say("こんにちは") )
```

---

### objectの定義
- クラスの定義に対して1つしか存在しないオブジェクトを簡単に定義できる
- classで定義したクラスと同名でobjectを定義するとコンパニオンオブジェクトになる
  - コンパニオンオブジェクト
    - お互いの非公開メンバにアクセスできる
    - implicitパラメータの解決時に使われることがある

```scala
object CatService {
  val serviceName = "猫製造機"
  def createByName(name :String): Cat = new Cat(name)
}
val mike = CatService.createByName("みけ")
mike.say("ねむい")

object Tama extends Cat("たま") {
  override def say(msg: String) : String =
    "たまにゃー"
}

object Cat { // すでにあるクラスと同じ名前だと
  // 定義されたメソッドはクラスメソッドのように振る舞う
  def create(name: String) : Cat = new Cat(name)
}
val hachi = Cat.create("はち")
```

---

### case classの定義
- クラスに似てる
- データ構造を定義しやすくカスタマイズされてる
- いくつかのメソッドがいい感じに生える
  - toString/hashCode
  - apply/unapply (コンパニオンオブジェクトに)

```scala
case class Cat(name: String) { // nameは勝手にfieldになる
  def say(msg: String) :String = ???
}
val buchi = Cat("ぶち") // newなしで気楽に作れる
buchi match {
  case Cat(name) => // パターンマッチで使える
    "name of buchi is " = name
}
```

---

### trait の定義
- 実装を追加できるインターフェース
- Scala では設計のベースになるクラスの構造を構築するのによく使われる
- Rubyのモジュールっぽいやつ

```scala
class Cat(n: String) {
  val name = n
}

trait Flyable {
  def fly: String = "I can fly"
}

// withで継承する/多重に継承できる
class FlyingCat(name: String) extends Cat(name) with Flyable
new FlyingCat("ちゃとら").fly

// Scalaで定義されているOrdered traitを実装すると比較できるように
class OrderedCat(name: String) extends Cat(name) with Ordered[Cat] {
   def compare(that: Cat): Int = this.name.compare(that.name)
}
new OrderedCat("たま") > new OrderedCat("みけ")
new OrderedCat("たま") < new OrderedCat("みけ")
```

#### sealed trait

traitをmixinしているcase classなどをパターンマッチで判定する場合、すべてのcase classに対してのマッチが考慮されているか、漏れを検出したいときがある。
そのようなときは、`sealed` を使えばよい

`sealed` 修飾子は、「同一ファイル内のクラスからは継承できるが、別ファイル内で定義されたクラスでは継承できない」という継承関係のスコープを制御するためのものだが、match式の漏れを検出する用途にも使える。

```scala

sealed trait HatenaService
case class HatenaBlog(name: String) extends HatenaService
case class HatenaBookmark(name: String) extends HatenaService
case class JinrikiKensakuHatena(name: String) extends HatenaService
case class Mackerel(name: String) extends HatenaService

val service: HatenaService = HatenaBlog("blog")

service match {
  case HatenaBlog(name) => name
  case HatenaBookmark(name) => name
  case JinrikiKensakuHatena(name) => name
}

<console>:16: warning: match may not be exhaustive.
It would fail on the following input: Mackerel(_)
              service match {
              ^
```

このように漏れているパターンを警告してくれる

#### traitの菱型継承について

##### 菱型継承とは
Scalaのtraitのように多重継承が可能な場合に、下図のような継承関係になる場合のこと。

![](https://upload.wikimedia.org/wikipedia/commons/8/8e/Diamond_inheritance.svg)

この場合、BとCでそれぞれAのメソッドをoverrideしていた場合、Dからはどのように見えるだろう？

```scala
trait A {
  val value = "A"
}

trait B extends A {
  override val value = "B"
}

trait C extends A {
  override val value = "C"
}

class D extends B with C

scala> (new D).value
res0: String = C
```

Cになる！

これをextendsする順番を入れ替えると...

```scala
class D extends C with B

scala> (new D).value
res0: String = B
```

Bになる！

Scalaでtraitを多重継承する場合、それぞれに親を同じとするoverrideメソッドが実装されていた場合、
withで連結されていく一番後ろの実装が優先される。

---

## Scala 紹介 その7

---

### implicit conversion/parameter
- 暗黙の型変換
- 暗黙のパラメータ
- 暗黙と聞いていいイメージはないが使いドコロをまちがわないことでいろいろできる

---

### 普通の型変換
```scala
def stringToInt(s:String) : Int = {
  Integer.parseInt(s, 10)
}

"20" / 5 // 型エラーになる
stringToInt("20") / 5 // ok
```

---

### 暗黙の型変換

```scala
implicit def stringToInt(s:String) : Int = { // implicit!!
  Integer.parseInt(s, 10)
}

"20" / 5 // 計算できる!!
```

- 要求する型が得られない時、スコープ中のimplicit宣言を調べて自動で変換する
- / の右側ところには数値型しか現れないはずなのに文字列があるのでimplicitで定義した変換関数が呼ばれた
- とはいえこれは異常なパターンでこんなことはしない...

---

### 使いどころ
- 既存の型を拡張するように見せられる(pimp my libraryパターン)

```scala
class GreatString(val s: String)  {
  def bang :String = {
    s + "!!!!"
  }
}
implicit def str2greatStr(s: String) : GreatString = {
  new GreatString(s)
}

"hello".bang // まるでStringに新しいメソッドが生えたように見える
```

---

### 暗黙のパラメータ
- 予め暗黙のパラメータを受け取る関数を定義
- 呼び出し時にスコープ中のimplicit宣言を調べて自動的に引数として受け取る

```scala
def say(msg: String)(implicit suffix: String) =
  msg + suffix

say("hello")("!!!!!") // => hello!!!!! 普通に読んだらこう
implicit val mySuffix = "!?!?!!1" // 暗黙のパラメータを供給
say("hello") // => hello!?!?!!1
```

---

#### 使いどころ1
- コンテキストオブジェクトを引き回す

```scala
def findById(id: Int, dbContext: DBContext) = ???
def findByName(name: String, dbContext: DBContext) = ???

val dbContext = new DBContext()
findById(1, dbContext)
findByName("hakobe", dbContext) // 毎回DBコンテキストを渡す必要があってだるい
```

```scala
def findById(id: Int)(implicit dbContext: DBContext) = ???
def findByName(name: String)(implicit dbContext: DBContext) = ???

implicit val dbContext = new DBContext()
findById(1)
findByName("hakobe") // dbContextは暗黙的に供給されるのでスッキリ
```

---

#### 使いどころ2
- 型クラスを実現できる
- アドホック多相を実現する
  - 関数の定義を型ごとに切り替えられる
  - スコープごとに切り替えることができる (アドホック)
  - 型のソースコードへのアクセス権限がなくても実装を提供できる (アドホック)
- くわしくは記事を読もう
  - http://nekogata.hatenablog.com/entry/2014/06/30/062342
  - http://eed3si9n.com/learning-scalaz/ja/polymorphism.html

```scala
// http://nekogata.hatenablog.com/entry/2014/06/30/062342 より引用
trait FlipFlapper[T] {
  def doFlipFlap(x:T):T
}
implicit object IntFlipFlapper extends FlipFlapper[Int] { // ...(1)
  def doFlipFlap(x:Int) = - x
}
implicit object StringFlipFlapper extends FlipFlapper[String] { // ...(2)
  def doFlipFlap(x:String) = x.reverse
}

def flipFlap[T](x:T)(implicit flipFlapper: FlipFlapper[T])
  = flipFlapper.doFlipFlap(x) // ...(3)

flipFlap(1) // => -1
flipFlap("string") // => "gnirts"
```

---

## Scala 紹介 その8

---

### 型パラメータ

ScalaのListなどは、そのListの要素がすべて同じ型であれば、StringとかIntとかいろいろな型を入れることができる。
このような定義を型パラメータという。

`List[A]` のように定義されていて、`A`の部分が型パラメータ。

`List[String]`と書くとそのListはStringのみ扱えるし、`List[Int]` と書くとIntのみ扱える。

```scala
val l: List[Int] = List("a","b") // コンパイルエラー
```

自分で定義した関数の引数の型を任意の型としたい場合など、このように定義できる
```scala
def example[A](l: List[A]): A = l.head

scala> example(List(1,2))
res: Int = 1

scala> example(List("a","b"))
res: String = a
```

型パラメータは柔軟に指定することができ、例えばあるクラスの派生クラスのみ受け取りたい、などの指定ができる。
より詳しく知りたい場合は、「型境界」「変位指定アノテーション」などのキーワードで調べてみよう!

---

## Scala 紹介 その9

---

### 複数の引数リスト

Scalaでは関数を定義するときに複数の引数リストを作ることができる

```scala
def example(x: Int)(y: Int) = x * y // こんな感じ

example(2)(4) // 使うときはこう書く
```

なにが嬉しいのか？？

値を取る引数と関数を取る引数を分けておくと、使う人が楽

```scala
def example(i: Int)(f: Int => Int) = f(i)

example(2) { i =>
  i * 2
}
```

このように`example`という新しいステートメントを定義したかのように書ける

### 可変長引数

Scalaで可変長引数を定義するときは

```scala
def example(ss: String*): Unit = ss.foreach(println)
```

のように書く。

こうすると、`example` は任意個のStringを受け取れるので、

```scala
example("AA")
example("AA", "BB")
example("AA", "BB", "CC")
```

のように文字列を任意個渡せるようになる。

ところで、可変長引数を受け取る関数内部では、引数は`Seq`で扱われる(なので`ss.foreach`とかできる)ので、そのままSeqを渡せそうだがそうはならない。

```scala
def example(ss: String*): Unit = ss.foreach(println)

val sq = Seq("AA", "BB")

scala> example(sq)
<console>:10: error: type mismatch;
 found   : Seq[String]
 required: String
              example(sq)
                      ^
```

可変長引数に対してコレクションを渡す場合はこう書く

```scala
def example(ss: String*): Unit = ss.foreach(println)

val sq = Seq("AA", "BB")

scala> example(sq:_*)
AA
BB
```

こうすると、コレクションの要素を可変長引数に１つずつ渡せるようになる

---

## Scala 紹介 その10

---

### 文字列補間

s"..."のように文字列リテラルの前にプレフィックスをつけることで、リテラル中に$nameの形で変数名を指定してその値を埋め込むことができる。

```scala
val name = "foo"
val value = 3
s"$name is $value" // => foo is 3
s"7 * 8 = ${7 * 8}" // このように式も書ける
```

---

## オブジェクト指向とか関数型プログラミングとかの話

Scalaはオブジェクト指向言語であり、関数型言語でもある。

### オブジェクト指向

オブジェクト同士の相互作用としてシステムの振る舞いを捉える。

オブジェクト指向言語の特徴
- 継承
- カプセル化
- ポリモーフィズム

---

#### 継承

すでに定義済みのオブジェクトの特性を受け継ぐこと

```scala

class Parent {
  def helloWorld = println("hello world")
}

class Child extends Parent {
  def helloChile = println("hello child")
}

scala> (new Child).helloWorld
hello world
```

このように、Parentを継承しているChildは親のクラスの特性を受け継ぐので、親クラスのメソッドが使える。

---

#### カプセル化

オブジェクト内部のデータを隠蔽したり(データ隠蔽)、オブジェクトの振る舞いを隠蔽したり、オブジェクトの実際の型を隠蔽したりすること。
これにより、オブジェクト内部でのみ呼び出せるメソッドなどを定義することで、無関係なオブジェクトからそれらを扱えなくして、プログラムの影響範囲を局所化できる。

```scala
class Capsule {
  private def secretMethod = println("秘密")

  def publicMethod = secretMethod
}

scala> (new Capsule).secretMethod
<console>:9: error: method secretMethod in class Capsule cannot be accessed in Capsule
              (new Capsule).secretMethod
                            ^

scala> (new Capsule).publicMethod
秘密
```

このようにメソッドは定義されているが外部からアクセスできないが、クラス内では使える

---

#### ポリモーフィズム

あるオブジェクトへの操作が呼び出し側ではなく、受け手のオブジェクトによって定まる特性

```scala

trait HelloWorld {
  def helloWorld: String
}

class En extends HelloWorld {
  def helloWorld: String = "hello world"
}

class Ja extends HelloWorld {
  def helloWorld: String = "こんにちは世界"
}

def printHelloWorld(hw: HelloWorld) = println(hw.helloWorld)

scala> printHelloWorld(new En)
hello world

scala> printHelloWorld(new Ja)
こんにちは世界
```

`printHelloWorld` メソッドはtraitを受け取り、その振る舞いを呼び出しているが、その結果は`printHelloWorld`に渡された実際のクラスの実装に委ねられる

---

### 関数型言語

Scalaはしばしば関数型言語である、と言われる。
関数型言語とは、「関数型プログラミングを推奨・支援するプログラミング言語」のこと。

ちなみに関数型プログラミングとは、できるだけ副作用を用いない参照透過な式や関数を組み合わせるプログラミングスタイルのことで、特に「これは関数型言語である!」と明確に言われていない言語であってもこのスタイルでプログラミングすることは可能。

言語として副作用を全く持たないものは純粋、副作用を持つものは非純粋と呼び分けられる(Scalaは副作用オッケーなので非純粋)。

Scalaには関数型プログラミングを支援する様々な仕組みがある。

---

#### 関数が第一級オブジェクトになっている

関数を引数に取ったり、関数の結果として返したり、変数に入れたりできる。
(関数を値として扱える)

```scala
val l = List(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)

// Listのfilterメソッドは、"Listの要素を引数にとり、Booleanを返す関数" を引数にとる
scala> l.filter(i => i % 2 == 0)
res1: List[Int] = List(2, 4, 6, 8, 10)

// isEvenは、"Intを引数に取り、その値を2で割って余りがあるかどうかを返す関数" を戻り値とする関数になる
scala> val isEven = (i: Int) => i % 2 == 0
isEven: Int => Boolean = <function1>

// isEvenの戻り値(関数)をfilterの引数として渡してる
scala> l.filter(isEven)
res2: List[Int] = List(2, 4, 6, 8, 10)
```

---

#### 副作用とは

- 変数の値を変更する(varを使う)
- オブジェクトのフィールドを変更する(JavaのsetterとかC# のプロパティとか)
- ファイルやデータベースなどに対する入出力

副作用の無いコードとは、参照透過性が保たれているということ

---

#### 参照透過性

- 同じ条件を与えれば必ず同じ結果が得られる
- 他のいかなる機能の結果にも影響を与えない

###### 参照透過なコード
```scala
scala> val x = "hatena intern"
x: String = hatena intern

scala> val r1 = x.reverse
r1: String = nretni anetah

scala> val r2 = x.reverse
r2: String = nretni anetah


scala> val r1 = "hatena intern".reverse
r1:String = nretni anetah

scala> val r2 = "hatena intern".reverse
r2:String = nretni anetah

// 変数xを"nretni anetah"に置き換えても結果は同じ
```

###### 参照透過でないコード
```scala
scala> val x = new StringBuilder("hatena")
x: StringBuilder = hatena

scala> val xa = x.append("intern")
xa: StringBuilder = hatena intern

scala> val r1 = xa.toString
r1: String = hatena intern

scala> val r2 = xa.toString
r2: String = hatena intern


scala> val r1 = x.append("hatena intern").toString
r1: String = hatena intern

scala> val r2 = x.append("hatena intern").toString
r2: String = hatena intern intern

// 変数xaを x.append("hatena intern")に置き換えると結果が変わる
```

参照透過なコードを書くことで、プログラマがオブジェクト内部の状態をいちいち気にしなくてよくなる。
(コードが参照透過でないと、オブジェクトの内部状態が今どうなっているか、など気にしないといけない)

#### そもそもなぜ副作用がない方がうれしいのか

- クラスなどの内部の状態を気にしないでよくなるので、見通しのよい、読みやすいコードになる
- 状態に依存しないので、テスタビリティにすぐれている
- 状態をあちこちで共有しないので、マルチスレッドにしたときに問題がおきない

#### Scalaにおける副作用

Scalaは関数型言語とオブジェクト指向言語の特徴を兼ね備えたマルチパラダイムな言語なので、手続き的な実装を認めている。
上の方で紹介したvarは、変数の再代入が可能だし、バリバリ副作用を起こせる。

ただ、せっかくだから関数プログラミングのメリットを活かしたいので、なるべく副作用の無い実装を心がけよう！

---

## プロジェクトのコードを書くにあたって知っておいてほしいこと

---

### テストを書こう

- プログラムを変更する二つの方法 [レガシーコード改善ガイドより]
  - 編集して祈る
  - テストを書いて保護してから変更する

#### なぜテストを書くのか

- テストがないと、プログラムが正しく動いているかどうかを証明できない
- 大規模プロジェクトでは致命的
  - 昔書いたコードは今もうごいているのか?
  - 新しくコードと古いコードの整合性はとれているのか?
  - 正しい仕様 / 意図が何だったのかわからなくなっていないか?
- 静的言語はコンパイラに守られているとはいえ、コードの振る舞いはテストを書かないと保証できない

祈らずテストを書こう！

#### なにをテストするのか

- 正常系
- 異常系
- 境界

- 100% の カバーは難しい
  - 命令網羅(C0) / 分岐網羅(C1) / 条件網羅(C2)
  - C2 とかはたいへん
- 必要 / 危険だと思われるところから書き、少しづつ充実する
- バグ修正で不具合の再現手順が面倒な場合は、不具合が再現するテストを先に書いたりする

### テストカバレッジ

#### C0(命令網羅)

```scala
  if(i >= 10) {
    println("true!");
  }
```

すべてのステートメントを通ればOK。
上の例だと、if文が真の場合しかテストされない（偽の場合のステートメントが無いので）

#### C1(分岐網羅)

分岐をすべて通るかを確認するテスト。

```scala
  if(i >= 10 || j == 0) {
    println("true!");
  } else {
    println("false!");
  }
```

上の例だと jの値を0に固定して、i == 1 の場合と i == 11の場合がテストされれば良い

#### C2(条件網羅)

すべての条件の組み合わせがテストされる。

```scala
  if(i >= 10 || j == 0) {
    println("true!");
  } else {
    println("false!");
  }
```

C1ではiの値でのみテストが行われたが、ここではjの値も含めて、それぞれのすべての条件の真偽値の組み合わせがテストされないといけない。

### テストを書くコツ

- まず、こういう振る舞いで有るべきというテストを書く
```scala
  sort(List(1,5,7,3,6)) shouldBe List(1,3,5,6,7)
  // Listにsortのメソッドはあるけど、例としてsort関数を自分で作ったと仮定してる
```

- 次に境界条件での振る舞いを検証するテストを書く
```scala
  sort(Nil) shouldBe Nil // Listが空の場合はそのまま空
  sort(List(99)) shouldBe List(99) // Listの要素がひとつしかなければそのまま
```

- 例外条件も確認
```scala
  an[IllegalArgumentException] should be thrownBy sort("hello")
```

### リファクタリング

- リファクタリングとは？
  - プログラムの振舞を変えずに実装を変更すること
- テストがなければ、外部機能の変更がないことを証明できない。
  - テストがなければリファクタリングではない
- レガシーなコードに対してはどうする？
  - まずは、テストを書ける状態にしよう。

テストを書いてリファクタリングし、常に綺麗で保守しやすいコードを書きましょう


### プロジェクトのコードを書く心構え

- コードが読まれるものであることを意識する
  - あとから誰が読んでもわかりやすく書く
  - 暗黙のルールを知る => コードを読みまくる
  - 変数や関数の名前には充分こだわる（実装者の意図を名前で伝える）
  - コードだけで意図を表現しづらければコメントも併用しよう
- テストを書いて意図を伝える(テストは自分が書いた関数のリファレンス実装になっていると最高)

## データモデリング

構築するソフトウェアにはどのような概念が登場するのか考えて分析してみよう。

以下ではIntern-Bookmarkを例に考えてみる。

### 登場する概念(モデル)

- `User` ブックマークをするユーザ
- `Entry` ブックマークされた記事(URL)
- `Bookmark` ユーザが行ったブックマーク

### 概念が持つ特性
各クラスがどのような特性を持っているか考えてみよう。

- User
  - ユーザの名前
- Entry
  - ブックマークされたURL
  - Webサイトのタイトル
- Bookmark
  - ブックマークしたUser
  - ブックマークしたEntry
  - コメント

### 概念間の関係

<div style="text-align: center; background: #fff"><img src="http://f.st-hatena.com/images/fotolife/h/hakobe932/20140725/20140725163235.png"></div>

- 1つのEntryには複数のBookmarkが属する (一対多)
- 1つのUserには複数のBookmarkが属する (一対多)

## 課題1-1

### データモデリング

Intern-Bookmarkのモデリングの講義を参考に簡単な"ブログシステム"を考えて、登場する概念(モデル)とその関係を考えてみましょう。
世の中のブログサービスには様々な機能がありますが、ここでは基本的な機能に絞って考えてもらって構いません。

- ブログを書く人(=ユーザ)は存在しそうですね
- 普通のブログサービスであれば、ユーザごとに個別のブログがありますね
  - [はてな匿名ダイアリー](http://anond.hatelabo.jp) のようにユーザ個別のブログが存在しないブログサービスもあるにはありますね
- ブログには記事がありますね

### モデリングに対応するオブジェクトの実装

先の課題で考えたデータモデリングに基づくオブジェクトを実装してください。
どのようなデータモデリングを行ったかによって各モデルのできることは微妙に異なりますが、以下のようなことができるようにしてください。

- ユーザーはブログに記事を書くことができる
- ブログは記事の集合を返すことができる

プログラムのインターフェースは自由です。以下に Blog クラスと Entry クラス、 User クラスを用いたサンプルを記しますが、必ずしもこの通りになっている必要はありません。

本日の課題で書いてもらうコードそのものは翌日以降の課程では使いません。

```scala
val user = User("daiksy")

val blog = user.addBlog("だいくしーblog")

println(blog.name) // だいくしーblog

// 工夫ポイント: タプルよりかっこいい方法がありそうだ!
val (addedBlog1, entry1) = blog.addEntry("今日の日記", "今日はインターン2日目。Scalaプログラムの基本編の講義を受けた。")
val (addedBlog2, entry2) = addedBlog1.addEntry("一昨日の日記", "今日はインターン初日。最高の夏にするぞ！！！")

val entries = addedBlog2.allEntries
entries.map(_.title).foreach(println) // "今日の日記", "一昨日の日記"
```

### テストに慣れる

「オブジェクトの実装」で実装したクラスの挙動についてのテストを記述してください。

上記の例であれば、 Blog クラスと Entry クラス、 User クラスのそれぞれについてのテストを書く、ということになります。

### 注意点

* できるだけテストスクリプトを書く
  * 少くとも動かして試してみることができないと、採点できません
  * 課題の本質的なところさえ実装すれば、外部モジュールで楽をするのはアリ
  * 何が本質なのかを見極めるのも課題のうち
* 余裕があったら機能追加してみましょう
* 講義および教科書から学んだことを課題に反映させる
* きれいな設計・コードを心がけよう
  * 今日のコードは翌日以降の課程では使いませんが、翌日以降は自分の書いたコードに手を入れていくことになります

## 課題1-2(オプション)

課題1-1が終わって、時間や気持ちや心に余裕があったり、やる気が漲っている場合はオプション課題に取り組んでみてください。

課題1-1で実装したブログもどきに、なにか機能を追加してそれに対するテストを書いてください。

追加機能の例を下記にあげます（ここにない機能でもOKです)
- コメント
- ページング
- 購読
- トラックバック
- リブログ
