# ScalaによるWebアプリケーション開発

WAFの実例を通じて実際の雰囲気を掴みましょう。

## 目次
- 4.1 Scalatraとは
- 4.2 scala-Intern-Bookmarkとは
- 4.3 ブックマーク一覧を作ってみよう
    - 4.3.1 URI設計
    - 4.3.2 Controllerを書こう
    - 4.3.3 Viewを書こう
    - 4.3.4 テストを書こう
- 4.4 他の機能も作ってみよう
- 4.5 URIを変更してみよう

## 4.1 Scalatraとは
rubyのSinatraライクなWAFです。簡単なWebアプリケーションを書くのには適しているといえるでしょう。

ではこれから、Scalatraを使ってWebアプリケーションを作っていきましょう。

その完成形のお手本を用意しました。この資料では説明しませんが、はてなOAuthによるユーザー認証まで作りこんでいるので資料のコードと若干内容が異なります。
以下の手順でcloneしてみてください。

```
git clone https://github.com/hatena/scala-Intern-Bookmark
```

## 4.2 scala-Intern-Bookmark とは

Scalatraを利用して作成したWebアプリの例です。

### ディレクトリ構成

```Bash
$ tree scala-Intern-Bookmark
scala-Intern-Bookmark
├── README.md
├── build.sbt
├── db
│   └── schema.sql
├── project
│   ├── build.properties
│   └── plugins.sbt
└── src
    ├── main
    │   ├── resources
    │   │   ├── application.conf
    │   │   └── logback.xml
    │   ├── scala
    │   │   ├── HatenaOAuth.scala
    │   │   ├── ScalatraBootstrap.scala
    │   │   └── internbookmark
    │   │       ├── cli
    │   │       │   └── BookmarkCLI.scala
    │   │       ├── model
    │   │       │   ├── Bookmark.scala
    │   │       │   ├── Entry.scala
    │   │       │   └── User.scala
    │   │       ├── repository
    │   │       │   ├── Bookmarks.scala
    │   │       │   ├── Entreis.scala
    │   │       │   ├── Identifier.scala
    │   │       │   ├── TitleExtractor.scala
    │   │       │   ├── TitleExtractorDispatch.scala
    │   │       │   ├── Users.scala
    │   │       │   └── package.scala
    │   │       ├── service
    │   │       │   ├── BookmarkApp.scala
    │   │       │   ├── Error.scala
    │   │       │   ├── Json.scala
    │   │       │   └── package.scala
    │   │       └── web
    │   │           ├── AppContextSupport.scala
    │   │           ├── BookmarkAPIWeb.scala
    │   │           ├── BookmarkWeb.scala
    │   │           └── BookmarkWebStack.scala
    │   ├── twirl
    │   │   └── internbookmark
    │   │       ├── add.scala.html
    │   │       ├── delete.scala.html
    │   │       ├── edit.scala.html
    │   │       ├── list.scala.html
    │   │       └── wrapper.scala.html
    │   └── webapp
    │       ├── WEB-INF
    │       │   └── web.xml
    │       └── stylesheets
    │           └── default.css
    └── test
        ├── resources
        │   └── test.conf
        └── scala
            └── internbookmark
                ├── helper
                │   ├── EntriesDBForTest.scala
                │   ├── Factory.scala
                │   ├── SetupDB.scala
                │   ├── UnitSpec.scala
                │   └── WebUnitSpec.scala
                ├── service
                │   └── BookmarkAppSpec.scala
                └── web
                    └── BookmarkWebSpec.scala
```

src/main/scala以下の重要な項目としては以下のとおり。
- src/main/scala/ScalatraBootstrap.scala
  - Scalatraの起動をおこなってるファイル
- src/main/resources/application.conf
  - アプリケーションの設定はここ
- src/main/scala/internbookmark/web/BookmarkWeb.scala
  - URLの設定はここ
- Model的なやつ
  - src/main/scala/internbookmark/service
    - メインアプリケーション
  - src/main/scala/internbookmark/model
    - データモデリング
  - src/main/scala/internbookmark/repository
    - 外部問い合わせ(データベースなど)
  - service/repository/modelを合わせて俗にいうModelっていう雰囲気です

### はてなアプリケーションの登録

- Intern Bookmakrを動かすには事前にはてなにアプリケーション登録が必要です

### 事前準備

```Bash
$ mysqlqladmin create internbookmark
$ mysqladmin create internbookmark_test
$ cd /path/to/scala-Intern-Bookmark
$ cat db/schema.sql | mysql -uroot internbookmark
$ cat db/schema.sql | mysql -uroot internbookmark_test
```

### テストサーバの起動

```Bash
$ sbt -Dhatenaoauth.consumerkey="hogekey" -Dhatenaoauth.consumersecret="fugasecret"
> container:start
# http://localhost:8080 でアクセスできる
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
| /bookmarks | ブックマーク一覧 |
| /bookmark/:id | ブックマークの permalink (:idは追加時に採番される) |
| /bookmark/add?url=url&comment=comment (POST) | ブックマークの追加 |
| /bookmark/:id/delete (POST) | ブックマークの削除 |


### 4.3.2 Controllerを書こう

以下のURI設計におけるブックマーク一覧(/)を例として、Controllerを作っていきます。

| パス | 動作 |
|------|------|
| /bookmarks | ブックマーク一覧 |
| /bookmark/:id | ブックマークの permalink (:idは追加時に採番される) |
| /bookmark/add?url=url&comment=comment (POST) | ブックマークの追加 |
| /bookmark/:id/delete (POST) | ブックマークの削除 |

#### まずはHello Worldから

src/main/scala/internbookmark/web/BookmarkWeb.scala に URLのpathとそれに対応する処理を書くようになっているので以下のようにすれば簡単にHello Worldをブラウザに表示できます。

```Scala
  get("/") {
    Ok("Welcome to the Hatena world!")
  }
```

Ok("Welcome to the Hatena world!")で出力を直接指定します。

もう少し大きなアプリケーション用のWAFだと、ルーティング設定(URLと処理のマッピング)とコントローラーは分離されているものが多いです。Scalatraはもう少し手軽なWAFなので、ルーティング設定とControllerが一緒になっています。

例えば、Mackerelで使っているPlay Frameworkでは以下のようにURLとそれに対応する処理のメソッド名を記述するroutesファイルというものがあります。

```
GET    /           Application.index
GET    /bookmarks  Bookmarks.list
```

#### ブックマーク一覧のControllerを作る

- `> run list` に対応
- Controllerがやるべきこと
    - ユーザのブックマーク一覧を取得
    - 取得したブックマーク一覧を出力(Viewに渡す)

```Scala
// src/main/scala/internbookmark/web/BookmarkWeb.scala

get("/bookmarks") {
  // userはSongmu決め打ち
  val currentUserName = "Songmu"
  // Userを取得
  val currentUser = repository.Users.findOrCreateByName(currentUserName)
  // ブックマーク一覧を取得
  val list = repository.Bookmarks.listAll(currentUser).toList
  // Viewを指定し、ブックマーク一覧をViewに渡す
  internbookmark.html.list(list)
}
```

- ユーザのブックマーク一覧の取得
- ビュー指定とデータの受け渡し
    - internbookmark.html.*(...) でviewのファイルの指定と、データの受け渡しができる

#### Controllerのロジックを分離する

- いろんなページで使うロジックはモデルに分離しておくべき
- Fat Controllerを避ける
- ユーザーが主体となってBookmarkの情報にアクセスするパターンは頻出
- ユーザー情報を持ったアプリケーションclassを定義する

```Scala
// src/main/scala/internbookmark/service/BookmarkApp.scala

package internbookmark.service

import internbookmark.model.{Bookmark, User}
import internbookmark.repository

class BookmarkApp(currentUserName: String) {
  def currentUser(implicit ctx: Context): User = {
    repository.Users.findOrCreateByName(currentUserName)
  }
  def list()(implicit ctx: Context): List[Bookmark] =
    repository.Bookmarks.listAll(currentUser).toList
}
```

先ほどのBookmarkWeb.scalaは以下のようにできる。

```Scala
// src/main/scala/internbookmark/web/BookmarkWeb.scala

get("/bookmarks") {
  app = new BookmarkApp("Songmu")
  internbookmark.html.list(app.list())
}
```

- Controllerにはロジックを書かないくらいの気持ちでいると、綺麗にかける(かも)
  - 例えばコントローラーでやっている処理を別の場所から再現可能か
- Intern-Bookmarkは俗にいうMVCのMの部分がもう少しレイヤー化されている
  - service
    - コアロジック
  - model
    - データのモデリング
    - データベースへのアクセスは **行わない**
  - repository
    - データベースへのアクセスを行う
    - modelへのマッピングを行いオブジェクトを返却する
    - Data Mapper Pattern
  - Controllerがserviceにアクセスし、serviceはrepositroyにアクセスしmodelを受け取りそれをControllerに渡す

なぜこうなっているのか？

- DDD的な設計アプローチ
- 適切なレイヤリングを行いそれぞれの責務が混在するのを避ける
- それぞれのレイヤー毎に再利用/差し替えしやすいように
- 静的言語だとこういう所しっかりやっておいたほうがいいみたいなのもありそう(私見)
  - テストしやすいとか

### 4.3.3 Viewを書こう

- Controllerで`html.list()`を指定しているので、src/main/twirl/internbookmark/list.scala.htmlが使われる
  - このファイルはTwirl(読み方はトゥワール?)というscalaのテンプレート形式になっている

### Twirl 入門

- play framwwork標準のテンプレートエンジン
  - 型安全なテンプレートエンジン
  - つまりコンパイルされる。あとは分かるな
  - Mackerelで採用
- Scalaのテンプレートエンジンは他にも
  - Lift template
  - Scalate

**the magic '@' character**

`@`以降に式が書ける。終了位置はよしなに判断してくれる。

#### 引数受け取り
- Controllerで渡した変数を受け取る
- ちゃんと型を書く
```
@(bookmarks: List[internbookmark.model.Bookmark])
```

#### 繰り返し処理
- 配列に対する繰り返し
- `@`と`for`と`(`の間はスペースを開けないように注意(これは`if`などでも同様)
```HTML
@for(bookmark <- bookmarks){
  <li><a href="@bookmark.entry.url">@bookmark.entry.title</a> - @bookmark.comment - @bookmark.createdAt.toStrin<a href="/bookmarks/@bookmark.id/edit">edit</a> <a href="/bookmarks/@bookmark.id/delete">delete</a></li>
}
```

#### 分岐処理

```HTML
@if(true){ ... } else { ... }
```

#### 外部テンプレートからの読み込み

```HTML
@widget.socialButtons()
@* include widget/socialButtons.scala.html *@
```

コントローラーからの呼出し同様にテンプレート名を指定してそのまま呼び出せます。

#### wrapperパターン

```HTML
// wrapper.scala.html
@(title: String)(content: Html)
<html><body>
@content
</body><content>
```

以下のようにして呼び出します。

```HTML
@wrapper {
    <p>Hello World!</p>
}
```

`{}` の内部が、wrapperに`content`として渡されます。

#### コメント

```HTML
@* コメント! *@
```

参考
- Twirl: https://github.com/playframework/twirl
- https://www.playframework.com/documentation/2.3.x/ScalaTemplates

#### ブックマーク一覧のViewを作る

Controllerで指定したViewはsrc/main/twirl/internbookmark/list.scala.htmlでしたね。そこに追加して行きましょう

```HTML
@(bookmarks: List[internbookmark.model.Bookmark])
@wrapper("Bookmarks"){
  <a href="/bookmarks/add">Add</a>
  <ul>
  @for(bookmark <- bookmarks){
    <li><a href="@bookmark.entry.url">@bookmark.entry.title</a> - @bookmark.comment - @bookmark.createdAt.toString <a href="/bookmarks/@bookmark.id/edit">edit</a> <a href="/bookmarks/@bookmark.id/delete">delete</a></li>
  }
  </ul>
}
```

- Controllerから渡したbookmarksにアクセスできている
- Twirlは自動でhtmlをエスケープしてくれている
  - 逆にエスケープをオフにする時はXSSに注意

### 4.3.4 テストを書こう

ここまでで機能は出来上がりましたが、作った機能にはテストを書きましょう。ここではHello Worldページの簡単なテストだけ書きます。詳しくはお手本コードを参照して、テストを書くようにしてください。

```Scala
class BookmarkWebForTest extends BookmarkWeb {
  override def createApp()(implicit request: HttpServletRequest ): BookmarkApp = new BookmarkApp(currentUserName()) {
    override val entriesRepository = EntriesForTest
  }

  override def isAuthenticated(implicit request: HttpServletRequest): Boolean =
    request.cookies.get("USER").isDefined

  override def currentUserName()(implicit request: HttpServletRequest): String = {
    request.cookies.getOrElse("USER", throw new IllegalStateException())
  }
}

class BookmarkWebSpec extends WebUnitSpec with SetupDB {

  addServlet(classOf[BookmarkWebForTest], "/*")

  val testUserName = Random.nextInt().toString
  def testUser()(implicit ctx: repository.Context): User =
    repository.Users.findOrCreateByName(testUserName)
  def withUserSessionHeader(headers: Map[String, String] = Map.empty) = {
    headers + ("Cookie" -> s"USER=$testUserName;")
  }

  describe("BookmarkWeb") {
    it("should redirect to login page for an unauthenticated access") {
      get("/bookmarks") {
        status shouldBe 302
        header.get("Location") should contain("/auth/login")
      }
    }

    it("should redirect to the list page when the top page is accessed") {
      get("/",
        headers = withUserSessionHeader()
      ) {
        status shouldBe 302
        header.get("Location") should contain ("/bookmarks")
      }
    }

    it("should show list of bookmarks") {
      get("/bookmarks",
        headers = withUserSessionHeader()
      ) {
        status shouldBe 200
      }
    }
  }
}
```

テストは以下のようにして動かします。特定のSpecを動かしたい場合は、testOnlyを使いましょう。

```Bash
$ sbt
> test
> testOnly internbookmark.web.BookmarkWebSpec
```

## 一旦おさらい

Scalatraとはでの開発の流れは

1. URIを決める
2. URIとControllerの紐付けを定義する
3. 紐付けたControllerを書いて、Viewにデータを渡す
4. 渡されたデータを使って、対応するViewを書く(twirlなど)

## 4.4 他の機能も作ってみよう

今度はbookmark追加を作ってみましょう。要件は以下のようにしてみます。

- GET /bookmark/add -> bookmark追加のフォーム
- POST /bookmark/add -> bookmark追加 + redirect

### Controllerを作る

```Scala
  get("/bookmarks/add") {
    internbookmark.html.add()
  }

  post("/bookmarks/add") {
    val app = createApp()
    (for {
      url <- params.get("url").toRight(BadRequest()).right
      bookmark <- app.add(url, params.getOrElse("comment", "")).left.map(_ => InternalServerError()).right
    } yield bookmark) match {
      case Right(bookmark) =>
        Found(s"/bookmarks")
      case Left(errorResult) => errorResult
    }
  }
```

- parameterを取得したい時は `params.get("url")` みたいに
  - GET /bookmark?url=...とか、POSTのbody parameter(formのinputのやつとか)とかをとれる
- redirectは`Found`(303)

#### Eitherを使ったエラー処理

- Controllerでのエラー処理にはEitherを使うと便利です
- 正常系の場合と異常系の場合で処理の切り分けをすっきり書けます
  - service層が返すエラーに応じて、クライアントに返却するエラーの内容を決定する
  - service層がサーバーエラーの情報を返すのではなくConttrollerでマッピングするのが良い

### Viewを書く

- GET /bookmark/add にはテンプレートが必要
- Controllerで指定したテンプレートはsrc/main/twirl/internbookmark/add.scala.html

```HTML
@()
@wrapper("Add Bookmark"){
  <form action="/bookmarks/add" method="POST">
    <dl>
      <dt><label for="url">URL:</label></dt><dd><input type="text" name="url" size="80" value=""/></dd>
      <dt><label for="comment">Comment:</label></dt><dd><input type="text" name="comment" size="80"  value=""/></dd>
    </dl>
    <input type="submit" value="Add"/> <a href="/bookmarks">List</a>
  </form>
}
```

- /bookmark/addにPostするform
  - inputで指定されている、url, commentをparameterとしてPOST

他の機能はこれまで説明した機能を用いて実装できるので、scala-Intern-Bookmarkを見てください！

## 4.5 URIを変更してみよう

ScalatraのURLパスは単純な文字列だけではなくパターンを指定してその値をできます。例えば以下のようにidを取得することができます。

パターンの指定はいろいろ柔軟な書き方があるので、詳しくは以下をごらんください。
<http://scalatra.org/2.4/guides/http/routes.html>

例

```Scala
get("/bookmarks/:id") {
  val app = createApp()
  (for {
    id <- params.get("id").toRight(BadRequest()).right
  ...
}
```

以下の書籍などを参考にして、URIの設計をしてみましょう。

参考書籍
- Webを支える技術 5章

## この章のまとめ

- Scalatraによる開発の流れは
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

## 意識すること

- Webアプリケーションには「あらゆる」ユーザー入力が想定される
  - あらゆるエンドポイントにあらゆるリクエストが飛んでくる可能性がある
- ユーザー入力のインプットとそのアウトプットに気を配る
  - 適切な入力値バリデーション(これはセキュリティというよりかはアプリケーションの作りの話)
  - 適切な出力エスケープ
    - 何がユーザー(外部)入力由来かを意識する

## 今回話すこと

- 攻撃方法は様々
- 今回はXSSについて簡単に話します
- さらに詳しくは「体系的に学ぶ 安全なWebアプリケーションの作り方　脆弱性が生まれる原理と対策の実践」を

## XSS

- XSSとはクロスサイトスクリプティング(Cross Site Scripting)の略
- ユーザの送ってきたスクリプトをページ内に埋め込まれて実行される脆弱性
- 様々な問題
  - 特定のユーザのログイン情報を抜き取る
  - サイトのページを改ざんされる

例えば今回のBookmarkアプリの一覧表示(/)で、ブックマークのコメントをユーザ入力のまま表示させてしまったとします

```HTML
@* twirlではHtml()を通すとhtmlエスケープされなくなる *@
<p>@Html(bookmark.comment)</p>
```

この場合以下のコメントに以下の文字が入っていると、jsが実行されてしまう

```
<script>alert('XSS')</script>
```

- 根本的な対策
  - 出力時に適切なエスケープをすること
  - 今回の場合は、Twirlが自動的にエスケープしてくれるので何もしなくて良い
  - ただし、明示的にHtml()でエスケープをしなくした場合は注意が必要

### 何が外部由来の入力か

「そりゃフォーム入力とかでしょ」

**他にもある!!**

- 周囲のWifiアクセスポイント一覧を出すWebサイト
  - Wifiアクセスポイント名に `<script>...` とか入っている可能性
- アップロードする画像のExifの中に `<script>` タグをしこむ
  - Exifの内容をエスケープせずにサイトに表示したらアウト

## 気をつけること

- 外部入力由来のデータに気をつける
  - テンプレートのオートエスケープ機構に頼る
  - SQLの組み立てはプレースホルダ必須
- 二重エスケープして `&lt;` とか出てしまうほうがマシ
  - それから対応を考えるでもいい

## 補足: バリデーションはセキュリティ対策か？

バリデーションはユーザーの入力値がアプリケーションの仕様に対して適切かどうかのチェックに過ぎません。なので厳密に言うとバリデーションそのものはセキュリティ対策ではありません。しかし、バリデーションをしっかりおこなうことは、不正な値がアプリケーションに紛れることを防ぐことにもなるので、結果的には堅牢なアプリケーション作りに役立つと言えるでしょう。

Scalatraには、 [Commands](http://www.scalatra.org/2.4/guides/formats/commands.html) というユーザーの入力値をケースクラスにマッピングしたり、バリデーションを行なったりする機能があります。

また、標準ではありませんが、 [scalatra-forms](https://github.com/takezoe/scalatra-forms) というPlay FrameworkのForm機能と似たような使い勝手のFormライブラリもあります。Scalatraのコミッターの方のライブラリなので、クオリティの心配はないでしょう。こちらをユーザー入力チェックのために使っても良いかもしれません。

## 課題3

- CLI版 Intern-Diary を Web アプリケーションにして下さい

### (必須)記事の表示

ブラウザですでに書かれたdiaryの記事を読めるように

- ブラウザで読めるように
    - テンプレートをちゃんと使って
    - 設計を意識しよう
    - 良いURI設計をしてみよう
- ページャを実装
    - OFFSET / LIMIT と ?page=? というクエリパラメータを使います
    - <strong>明日課題に繋がるので必須です</strong>

### (必須)記事作成/編集/削除

- ブラウザで書けるように
- ブラウザで更新できるように
- ブラウザで削除できるように

### (オプション)追加機能

以下の様な追加機能をできる限り実装してみてください。

例)

- 認証 (Hatena/Twitter OAuth)
- フィードを吐く (Atom, RSS)
- デザイン
- 管理画面
- いろいろ貼り付け機能
- その他自分で思いついたものがあれば

### 注意

- 全然分からなかったらすぐに人に聞きましょう

## 参考：ユーザ認証層

- 以下のように複数のアプリケーションをmountできる
- 認証処理の実装自体はHatenaOAuth.scala参照のこと

```Scala
// src/main/scala/ScalatraBootstrap.scala
import internbookmark._
import jp.ne.hatena.intern.scalatra.HatenaOAuth
import org.scalatra._
import javax.servlet.ServletContext
import internbookmark.service.Context

class ScalatraBootstrap extends LifeCycle {
  override def init(context: ServletContext): Unit = {
    Context.setup("db.default")
    context.mount(new internbookmark.web.BookmarkWeb, "/*")
    context.mount(new HatenaOAuth, "/auth")
  }

  override def destroy(context: ServletContext): Unit = {
    Context.destroy()
  }
}
```

## 参考資料

- http://scalatra.org/2.4/guides/
- https://www.playframework.com/documentation/2.3.x/ScalaTemplates

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/2.1/jp/"><img alt="クリエイティブ・コモンズ・ライセンス" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/2.1/jp/88x31.png" /></a><br />この 作品 は <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/2.1/jp/">クリエイティブ・コモンズ 表示 - 非営利 - 継承 2.1 日本 ライセンスの下に提供されています。</a>
