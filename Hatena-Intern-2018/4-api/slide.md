# 今日のテーマ
- セキュリティ
- APIとGraphQL
- フロントエンド開発環境

盛りだくさんだけどがんばろう！

---

# 自己紹介

- id:hakobe932/@hakobe
- ゲームチーム/チーフエンジニア
- 好きな技術: 設計/マイクロサービス/プログラミング言語
- 大学時代に打ち込んだこと: 田村ゆかり

---

![inline 240%](https://cdn.profile-image.st-hatena.com/users/hakobe932/profile.gif?1512697682)

---

# セキュリティ

---

# セキュリティ
- セキュリティが守られていないソフトウェアには大きなリスクがある
    - ユーザの大切なデータが盗まれたり壊されたり利用不可能に
    - 企業の機密情報の漏洩
- Webサイトの脆弱性も格好の標的

---

# 事例

- [PlayStation Networkの個人情報漏洩](http://cdn.jp.playstation.com/msg/sp_20110427_psn.html)
  - 氏名/住所/パスワードなどが漏洩
  - クレジットカード情報はおそらく無事
- 原因: [SQLインジェクション - Wikipedia](https://ja.wikipedia.org/wiki/SQL%E3%82%A4%E3%83%B3%E3%82%B8%E3%82%A7%E3%82%AF%E3%82%B7%E3%83%A7%E3%83%B3)

---

# セキュリティの定義

正当な権利をもつ個人や組織が、情報やシステムを意図通りに制御できること

- 機密性: 許可されたひとだけがアクセスできる
- 完全性: 意図された処理が正しく完了できる
- 可用性: システムが必要なときに利用できる

これらを脅かす攻撃からシステムを守る必要がある

---

# 脆弱性対策の基本

1.根本的対策
  - 脆弱性を作り込まない実装をする
2.保険的対策
  - 攻撃による影響を軽減する

1を基本に、もしものときに備えて2をやる

---

# 基本的な脆弱性と対策

- SQLインジェクション
- XSS
- CSRF

---

# SQLインジェクション
- 任意のSQLを実行されてしまう脆弱性
  - データを破壊したり、結果を取得して機密情報を盗んだり
- ユーザの入力をそのままSQLに埋め込むことで発生

```go
// http://myapi.test/user?user_id=1

query := "SELECT * FROM user WHERE ID = " + req.FormValue("user_id")
db.Query(query)
// => SELECT * FROM user WHERE ID = 1
```

---
# 入力値にSQLを埋め込める
任意のクエリを発行可能!

```go
// http://myapi.test/user?user_id=1%3BDELETE%20FROM%20user%3B

query := "SELECT * FROM user WHERE ID = " + req.FormValue("user_id")
db.Query(query)
// => SELECT * FROM user WHERE ID = 1; DELETE FROM user;
```


---
# 対策: プレースホルダを使う
SQLのドライバに付属する機能

```go
query := "SELECT * FROM user WHERE ID = ?"
db.Query(query, 1)
// => SELECT * FROM user WHERE ID = 1

db.Query(query, "; DELETE FROM user;")
// => SELECT * FROM user WHERE ID = '1; DELETE FROM user';
```

みなさんが使ってるsqlxでも同じ

---

# XSS: クロスサイトスクリプティング
- サイト上で任意のスクリプトを実行されてしまう脆弱性
  - サイトの内容を書き換えられる
  - Cookieを盗まれてセッションハイジャックされる
- ユーザの入力をそのままHTMLやCSSに埋め込むことで発生
  - JavaScriptによっても発生するので注意

---

# XSSの例 1

テンプレート

```html
{{define T}}<h1>Hello! {{.}}</h1>{{ end}}
```

レンダリング

```go
t, err := template.New("foo").Parse(tmpl)
m := template.HTML(req.FromValue("message")) // エスケープ不要の印を付ける
t.ExecuteTemplate(out, "T", m)
```

※わざわざ入力値のエスケープを無効にしてる

---

# XSSの例 1

値が有効なHTMLとして埋め込まれるのでscriptが実行可能に

```
GET /hello?message=%3Cscript%3Ealert(1)%3B%3C%2Fscript%3E
# message=<script>alert(1);</script>
```

```html
<h1>Hello! <script>alert(1);</script></h1>
```


---

# XSSの例 2

jQueryでHTMLを構築するときなどに発生

だめな例

```javascript
$('<h1>' + bookmark.comment +'</h1>')
```

正しい例

```javascript
const e = $('<h1></h1>')
e.text(bookmark.comment)
```

---
# XSSのデモ

背景を変えていたずらできる

```
<script> document.body.style.backgroundColor = 'red'; </script>
```

別のサイトに移動させることができる

```
<script> location.href = 'http://www.tv-asahi.co.jp/zi-o/'; </script>
```

セッション情報を引き抜ける

```
<script> alert(document.cookie); </script>
```

---
# 対策

- テンプレートへの文字列埋め込み時には必ずエスケープする
  - Goのhtml/templateを使えば自動的にやってくれる!
- URLを出力するときは`http://`や`https://`のみを許可
  - Goのhtml/templateを使えば自動的にやってくれる!!
  - Reactでも無理しなければ自動的にやってくれる!!

あえてHTMLの入力をゆるしたい場合は慎重なプログラミングが必要

---

# 対策(続き)

- スタイルシートにも注意 (expreassion())
- 重要なCookieにhttponly属性を付与する
- X-Content-Type-Options: nosniff
  - 古いIEでJavaScript以外のものが評価されないように
- X-XSS-Protection: 1; mode=block
  - ブラウザの対策機能を有効にする
- Content-Security-Policy ヘッダの活用

---

# Content-Security-Policy ヘッダ

- ブラウザが読み込んでも良いリソースのポリシーを設定できる
- 指定されたスクリプト以外はインラインやHTML属性のイベントハンドラも無視される
- 参考: [https://developer.mozilla.org/ja/docs/Web/HTTP/CSP](https://developer.mozilla.org/ja/docs/Web/HTTP/CSP)

---

# CSP ヘッダの例

```
Content-Security-Policy:
  default-src 'self';
  img-src *;
  media-src media1.com;
```

- デフォルトでは元のホストのみを信頼
- 画像はどこでもOK
- 音声や動画はmedia1.comを信頼

---
# おまけ: XSS対策の歴史

```html
ようこそ [% user.nickname | html %] さん
```

- ` | html` がないと、エスケープ**されない**
- 一つでも忘れるとXSSになって危険だった

---
# 意識しよう: ユーザの入力値を信じない!
- ディレクトリトラバーサル
- OSコマンドインジェクション
- HTTPヘッダインジェクション

ユーザの入力を素通しするとこういう脆弱性がやってくる。どのようにエスケープするかは対策するものによる。

---

# CSRF: クロスサイト・リクエスト・フォージェリ

- 意図せずログイン状態のリクエストを発生させられてしまう脆弱性
  - 意図しない投稿/商品購入/退会処理など
- 投稿元のWebサイトをチェックしないことで発生
- デモ

---

# 対策: CSRFトークンを利用する

- POSTリクエストにユーザごとに秘密のトークンを含める
    - HTMLのformのhiddenパラメータやリクエストヘッダに含めることが多い
- サーバ側で投稿された秘密のトークンが正しいかどうかをチェック
- サンプルコードでは[justinas/nosurf](https://github.com/justinas/nosurf)を利用

---

# その他の脆弱性

- クリックジャッキング
- バッファオーバーフロー
- サイドチャネル攻撃
  - [Side-channel attacking browsers through CSS3 features](https://www.evonide.com/side-channel-attacking-browsers-through-css3-features/)

---

# 運用レベルでの対策
- OSやソフトウェアの継続的アップデート
- HTTPSの採用
- 強力な認証方法の採用
- WAFの利用

---

# 参考資料
- [IPA 独立行政法人 情報処理推進機構：情報セキュリティ](https://www.ipa.go.jp/security/)
  - [安全なWebサイトの作り方](https://www.ipa.go.jp/security/vuln/websecurity.html)
  - [安全なSQLの呼び出し方](https://www.ipa.go.jp/security/vuln/websecurity.html#sql)
  - [セキュアプログラミング講座](https://www.ipa.go.jp/security/awareness/vendor/programming/index.html)
- [Japan Vulnerability Note](https://jvn.jp/)

---

# API

---

# API is 何

* API = Application Programming Interface
* ソフトウェアコンポーネントをプログラムから操作するためのインターフェース
* 例) WebサービスのAPI, データベースのAPI, ライブラリのAPI

---

# 広く公開されたAPI

- 目的: 特定のサービスのエコシステムの拡大や利便性の向上
- 利用者: 任意の開発者
- 例) Twitter, Facebook, GitHub, はてなブログ

---

# 例) GitHub

- GitHubの情報を使ったアプリケーションが簡単に作れる
- ルールにしたがって利用する
  - アプリケーションをサイトに登録
  - アプリケーションごとにリクエスト頻度などの制限がある
- [ドキュメント](https://developer.github.com/v3/)

---

# 例) はてなブログ

- AtomPub仕様に準拠したAPI
  - 記事の取得/新規作成/更新/削除
- [ドキュメント](http://developer.hatena.ne.jp/ja/documents/blog/apis/atom)

---

# 特定のフロントエンドのための専用API
- 目的: 特定のWebサイトで動的なWebページを構築する
- 利用者: Webサイトの開発者
- 特定の機能を実現するための専用の設計

---

# 例) はてなブログの内部API

- はてなブログのフロントエンドが使う
  - 多様な機能/用途に合わせた形式
  - ユーザには公開されていない
- 例: [はてなブログの管理画面](http://blog.hatena.ne.jp)

---

# 対象となる開発者が違う
- Large Set of Unknown Developers (LSUDs)
- Small Set of Known Developers (SSKDs)

用途によってAPIの性質を決めよう

[.footer: [The future of API design: The orchestration layer](https://thenextweb.com/dd/2013/12/17/future-api-design-orchestration-layer/) より]

---

# APIの目的に合わせた設計


- APIの形式
- 認証方法
- ドキュメンテーション

---

# 課題で作るAPIの場合

フロントエンド向けの内部APIを作る(SSKD)

- APIの形式: JavaScriptから使いやすい形式
- 認証方法: HTML配信と同じでも良い
- ドキュメンテーション: 内部向けの簡潔なもの

---

# API形式
フロントエンド向けに適切な形式

- 基本: REST
- 新技術: GraphQL

☆ 最終的にはGraphQLを使います

---

# REST

---

# REST

- REST = Representational State Transfer
  - ステートレス
  - リソースをURIで識別する
  - HTTPメソッドによる操作
  - ハイパーメディア形式によりリソースの参照をたどって扱える

---

| メソッド | 操作 |
| ---- | ---- |
| POST | 新規作成(Create) |
| GET | 取得(Read) |
| PUT | 更新(Update) |
| DELETE | 削除(Delete) |
| PATCH | 部分更新(Patch) |

---

| ステータスコード | 意味 |
| ---- | ---- |
| 200 | OK |
| 201 | Created |
| 204 | No Content |
| 400 | BadRequest |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 405 | Method Not Allowed |
| 500 | Internal Server Error |

---

# 例) AtomPub API (はてなブログ)

- RESTに準拠している
- ブログのような記事配信のためのプロトコル
- [RFC5023 Atom Publishing Protocol](http://www.ietf.org/rfc/rfc5023.txt)
- [はてなブログAtomPub](http://developer.hatena.ne.jp/ja/documents/blog/apis/atom)
- 見てみましょう

---

# REST Pros.

- ステートレスで使いやすい
- ハイパーメディアの思想
- HTTPのセマンティクスは理解しやすい

# REST Cons.
- 操作的なものなど、リソースという概念で実装するのが難しいものがある
  - 例: `/bookmarks/search` 取得と検索は違う
- 厳密な準拠には手間がかかる

---

# REST の現実

- 完全にRESTの考え方に準拠しているものは少ない
- RESTっぽいもの(=REST-like)が多数
  - リソースはURIでアクセスできる
  - HTTPメソッド以外の操作もURLで表現
  - ハイパーメディアの機能はない
- 安易にRESTという言葉を使うと厳密なREST主義者の人には怒られる

---

# 例) GitHubのAPI
- [GitHub API v3](https://developer.github.com/v3/repos/)
- 見てみよう

---

# GraphQL

---

# REST-like APIの課題

- データ取得の効率やデータの表現の都合で様々なAPIが林立する
  - 特にフロントエンド向けのAPIで..
- 微妙な用途の差により都度APIの実装が必要
  - 加えてメンテナンスコストも増大

---

# 最適なデータ取得を行う専用APIの作成

- `http://myapi.test/bookmarks_with_user`
- `http://myapi.test/bookmarks_with_user_and_entry`
- `http://myapi.test/bookmarks_with_user_and_entry&simple=1`

---

# GraphQL

- APIのためのクエリ言語とその実装
- クエリを使って入れ子になったデータ構造を柔軟に取得できる
  - 用途ごとのAPIは不要に
- 優秀なクライアントライブラリもある ([Apollo](https://www.apollographql.com/))
  - 明日紹介

---

# 例) GraphQL リクエスト1

あるURLのブックマーク一覧を表示する

```sh
POST http://localhost:8000/graphql
{
  getEntry(entryId: "25699773679927297") {
    url
    title
    bookmarks {
      comment
    }
  }
}
```

---

# 例) GraphQL レスポンス1

```javascript
200 OK
{
  "data": {
    "getEntry": {
      "url": "https://example.com",
      "title": "Example Domain",
      "bookmarks": [
        {
          "comment": "hogehoga",
        },
        ...
      ]
    }
  }
}
```

---

# 例) GraphQL リクエスト2

ユーザ名も表示したい!

```sh
POST http://localhost:8000/graphql
{
  getEntry(entryId: "25699773679927297") {
    url
    title
    bookmarks {
      comment
      user {
        name
      }
    }
  }
}
```

---

# 例) GraphQL レスポンス2

```javascript
200 OK
{
  "data": {
    "getEntry": {
      "url": "https://example.com",
      "title": "Example Domain",
      "bookmarks": [
        {
          "comment": "hogehoga",
          "user": {
            "name": "scomb"
          }
        },
        ...
      ]
    }
  }
}
```

---

# GraphiQL

- GrqphQLを試すためのUI → [デモ](http://localhost:8000/graphiql)
- Intern-Diaryにも付属しています

---

# GraphQLサーバの実装

- スキーマを定義する
    - クエリによって取得できるデータ構造の定義
- `resolver` を実装する
    - クエリに対応するデータを取得する関数
- ライブラリを使ってHTTPサーバに組み込む

---

# スキーマ

- GraphQLのAPIから取得できるデータ型とその関係(グラフ!)を定義する
- データ型はフィールドを持つ
  - 各フィールドの型はGraphQLの仕様で定義されたもの
  - or 自分で定義したデータ型
- スキーマに定義されたとおりにフィールドを組み合わせてクエリを発行できる
- `schema` 以下に定義された `query` と `mutation` は特別な意味
- [見てみよう](https://github.com/hatena/go-Intern-Bookmark/blob/master/resolver/schema.graphql)

---


# データの取得用スキーマ(Query)

`query` に指定された、typeに定義されたフィールドをトップレベルのクエリとして呼び出せる

```
type Query {
    visitor(): User!
    getUser(userId: ID!): User!
    getBookmark(bookmarkId: ID!): Bookmark!
    getEntry(entryId: ID!): Entry!
    listEntries(): [Entry!]!
}
```

- `(...)`の中は引数、`:`以降は返り値の型

---

# Entry

`getEntry`から得られる`Entry`のデータ構造を定義

```
type Entry {
    id: ID!
    url: String!
    title: String!
    bookmarks: [Bookmark!]!
}
```

`bookmarks` は`Bookmark`のリスト
`!`は`null`を許さないという意味

---

# Bookmark と User

```
type Bookmark {
    id: ID!
    comment: String!
    user: User!
    entry: Entry!
}
```

```
type User {
    id: ID!
    name: String!
    bookmarks: [Bookmark!]!
}
```

---

# クエリの例(再掲)

スキーマにより以下のようなクエリを受け付けてくれるようになる

```sh
{
  getEntry(entryId: "25699773679927297") {
    url
    title
    bookmarks {
      comment
      user {
        name
      }
    }
  }
}
```

---
# データの取得方法の定義: `resolver`

- `type` のフィールドごとに `resolve` を定義する
- `getEntry` に対して `GetEntry` 関数を定義
  - 先頭が大文字になっていることに注意

---

```go
func (r *resolver) GetEntry(
  ctx context.Context, args struct{ EntryID string }) (*entryResolver, error) {
	entryID, err := strconv.ParseUint(args.EntryID, 10, 64)
	entry, err := r.app.FindEntryByID(entryID)
	if entry == nil {
		return nil, errors.New("entry not found")
	}
	return &entryResolver{entry: entry}, nil
}
```

---

# `resolver` はデータ構造に合わせて定義する

- フィールドに対応する値か`resolver`構造体を返す
  - 自分で定義した`type`なら`resolver`構造体(例 `entryResolver`)
  - GraphQLで定義済みの`type`ならそのまま返す(例 string)
- `type`ごとの`resolver`構造体がデータの取得方法を知っている
- データ構造を再帰的にたどりながら`resolve`することで、データ全体を作ることができる仕組み

---

# `GetEntry`が返す`entryResolver`にさらに`resolver`メソッドを定義

```go
type entryResolver struct {
	entry *model.Entry
}

func (e *entryResolver) ID(ctx context.Context) graphql.ID {
	return graphql.ID(fmt.Sprint(e.entry.ID))
}

func (e *entryResolver) URL(ctx context.Context) string {
	return e.entry.URL
}

...
```

---

# ライブラリを使って組み込む: `graphql-go`

- 課題では[graphql-go](https://github.com/graph-gophers/graphql-go)を使う
- スキーマと`resolver`メソッドを定義した構造体を `MustParseSchema` にわたす形

```go
graphqlSchema, err := loadGraphQLSchema()
schema := graphql.MustParseSchema(string(graphqlSchema), newResolver(app))
return &relay.Handler{Schema: schema}
```

---

```go
type query struct{}

func (_ *query) Hello() string { return "Hello, world!" }

func main() {
  s := `
          schema {
                  query: Query
          }
          type Query {
                  hello: String!
          }
  `
  schema := graphql.MustParseSchema(s, &query{})
  http.Handle("/query", &relay.Handler{Schema: schema})
  log.Fatal(http.ListenAndServe(":8080", nil))
}
```

```sh
$ curl -XPOST -d '{"query": "{ hello }"}' localhost:8080/query
```


---

# データの変更 (Mutation)
- 更新系のクエリは`Mutation`として定義する習わし
- 基本は`Query`と一緒だがresolver内で作成や更新処理を行って良い

```
type Mutation {
    createBookmark(url: String!, comment: String!): Bookmark!
    deleteBookmark(bookmarkId: ID!): Boolean!
}
```

---

# GraphQL Pros.

- 必要なデータをクエリを使って柔軟に取得できる
  - Backend For Frontend (= BFF) に最適
  - 用途ごとのAPIをはやしたり、たくさんAPIを呼ぶ必要がない
  - 機能を作るたびにAPIを変更する必要がない
- スキーマから型情報を生成して利用できる
  - クライアントが対応データ型を生成して安全に利用可能

---

# GraphQL Cons.
- `resolver`の書き方によっては特定のクエリで非常にパフォーマンスが悪くなるので、実装に注意が必要
- 第三者が複雑なクエリを発行して攻撃できないように気をつける必要
  - クエリの階層の深さや複雑さをチェックする
  - [Security and GraphQL Tutorial](https://www.howtographql.com/advanced/4-security/)
- HTTPのセマンティクスを無視しているところがあるので既存の技術が利用しにくい
  - キャッシュとか


---

# パフォーマンスを改善する

- フィールドに対応する`resolver`を単純に実装するとパフォーマンスが悪い
- DataLoaderという仕組みを使ってデータ取得を遅延評価する方法がある

---

# シンプルな `resolver`  の実装

```go
func (b *bookmarkResolver) User(ctx context.Context) (*userResolver, error) {
  user, _ := b.app.FindUserByID(b.bookmark.UserID)
  return &userResolver{user: user}, nil
}
```

- bookmarkのuserフィールドを評価するたびに呼び出される
    - = bookmarkの数だけSQLが発行される
- SQLの呼び出しを繰り返し行うのは高価

---

# パフォーマンスが良くないGraphQLのクエリ

```
{
  getEntry(entryId: "97774362819559425") {
    bookmarks {
      user {
        name
      }
    }
  }
}
```

- `bookmark`ごとに`user`フィールドが評価される
  - `bookmark_resolver`の`User`メソッドが`bookmark`の個数だけ呼び出される
- いわゆるN+1問題

---

# より複雑なクエリ

```
{
  getEntry(entryId: "97774362819559431") {
    bookmarks {
      user {
        bookmarks {
          entry {
            bookmarks {
              user {
                name
              }
            }
          }
          user {
            name
          }
        }
      }
    }
  }
}
```

- すごくたくさんUserの取得が発生する
- そもそもこういうクエリを許して良いのかという別の話題もある

---

# DataLoader
- データの取得処理を遅延させて、取得処理をまとめて行える仕組み
  - 原典は [Facebook dataloader](https://github.com/facebook/dataloader)
- GraphQLの`resolver`のように、取得したいものを一つづつしか指定できないが、パフォーマンスなどの理由で取得は一度にやりたいときに便利
- Intern-Bookmarkでは `loader`パッケージにまとめられている

---

# Load

```go
// from loader/user.go
func LoadUser(ctx context.Context, id uint64) (*model.User, error) {
	ldr, _ := getLoader(ctx, userLoaderKey)
	data, _ := ldr.Load(ctx, userIDKey{id: id})()
	return data.(*model.User), nil
}
```

- リクエストごとにloaderが作られる
- Loadメソッドで取得したいIDを指定する
  - すぐには取得は実行せず他のLoadの呼び出しを待つ
  - ある程度Loadが呼び出されてIDが集まってきたら一度に取得する

---

# BatchFunc
- 集まってきたIDの列をもとに一度にデータを取得するための関数
    - IDの列と同じ順番で結果を返す
- 取得には、`app.ListUsersByIDs(userIDs)` のように効率よく一度にデータを取得するメソッドを使う
    - SQLのWHERE INを使ってデータを一度に取得する
- loaderを作る時に指定する

---

# BatchFuncの例

```go
// from loader/user.go
func newUserLoader(app service.BookmarkApp) dataloader.BatchFunc {
	return func(ctx context.Context, userIDKeys dataloader.Keys) []*dataloader.Result {
		results := make([]*dataloader.Result, len(userIDKeys))
		userIDs := make([]uint64, len(userIDKeys))
		for i, key := range userIDKeys {
			userIDs[i] = key.(userIDKey).id
		}
		users, _ := app.ListUsersByIDs(userIDs)
		for i, userID := range userIDs {
			results[i] = &dataloader.Result{Data: nil, Error: nil}
			for _, user := range users {
				if userID == user.ID {
					results[i].Data = user
					continue
				}
			}
			if results[i].Data == nil {
				results[i].Error = errors.New("user not found")
			}
		}
		return results
	}
}
```

---

# GraphQL参考資料
- [GraphQL](https://graphql.org/)
- [GraphQL Spec](http://facebook.github.io/graphql/June2018/)
- [How to GraphQL](https://www.howtographql.com/)
- [graphql-go](https://github.com/graph-gophers/graphql-go)
- サンプルコード
    - [go-graphql-starter](https://github.com/OscarYuen/go-graphql-starter)
    - [graphql-go-example](https://github.com/tonyghita/graphql-go-example)

---

# フロントエンド開発環境
- TypeScriptによるフロントエンド開発環境
- モジュールの依存関係解決とバンドルに[Webpack](https://webpack.js.org)を使う

---

# JavaScriptのモジュール

[ES2015 Module](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Statements/import)

- foo.js:
    - `export const foo = function () { return 0; };`
- index.js:
    - `import { foo } from 'foo';`

少し古いブラウザやIEではまだ動かない

---

# WebPack

- JSのモジュールの解決とバンドルをしてくれる
- 様々なフロントエンドリソースを扱う機能(loader)
    - スタイルシートや画像をモジュールのように読み込み
    - JS読み込み時にTypeScriptにコンパイルする
- 便利な機能いろいろ

---

# 設定の例

```javascript
module.exports = {
  mode: "development",
  devtool: "inline-source-map",
  entry: "./src/index.ts", // このファイルが起点
  output: {
    filename: "index.js" // このファイルが出てくる
  },
  resolve: {
    extensions: [".ts", ".tsx", ".js"]
  },
  module: {
    rules: [
      { test: /\.tsx?$/, loader: "ts-loader" } // .ts や .tsx ファイルがts-loaderにより処理される
    ]
  }
};
```

---

# 課題: セキュリティ

- オプション課題
  - `<script>`タグを含む文字列を日記に投稿してみてどうなるか観察してみましょう
  - SQLインジェクションがあえて発生するようなコードに変更して攻撃してみましょう
  - セッションクッキーをHTTPOnlyにしてみて、なぜ安全になるか調べてみましょう

---

# 課題 GraphQL APIの実装
- 次のようなGraphQLのクエリが呼び出せるようにしよう
  - User/Diary/Articleも定義
  - 自分のIntern-Diaryに合わせて変更してよい


- `query`
    - `visitor` # アクセスしているユーザのこと
    - `user(userId: ID!): User!`
    - `diary(diaryId: ID!): Diary!`
- `mutation`
    - `createDiary(name): Diary!`
    - `deleteDiary(diaryId: ID!): Boolean!`
    - `postArticle(diaryId: ID!, title: String!, body: String!): Article!`
    - `updateArticle(entryId: ID!, title: String!, body: String!): Article!`
    - `deleteArticle(entryId: ID!): Boolean!`

---

# ポイント

- `User` や `Diary` からたどって`Article`のタイトルや本文を取得できるようなスキーマを定義しよう
    - 明日このAPIを使ってフロントエンドを作るので記事が読めるようにしたい
- 必要な`app`メソッドがあれば追加実装しよう
- Intern-Bookmarkのコードを良く読んで真似しよう

---

# ステップ1 スキーマの定義

- `resolver/schema.graphql` にスキーマを定義する
  - Intern-Bookmarkや[GraphQLのドキュメント](https://graphql.org/learn/)を参考に
- ヒント: 一気に全部やらず最低限だけ定義して次に進むと吉
  - 例えばまず`user(userId:ID!)`から`User`の名前だけが取得できるものを作って見よう

---

# ステップ2 resolverの実装

- `resolver/resolver.go` に`resolver`構造体とそのメソッドを定義する
- データ構造に合わせて `resolver/user_resolver.go` なども作っていく
- ヒント:
  - `resolver`の中では `app`のメソッドを呼び出してデータを取得しよう
  - `resolver`はリストを返しても良いぞ
  - Intern-Bookmarkのコードでは`loader`が登場するが一旦スルーして`app`のメソッドを呼び出して良い
    - `resolver`の構造体の中に`app`を保持するようにしておく

---
# ステップ3 handlerへの設定

- `resolver/handler.go` で スキーマと`resolver`をつかって`graphql-go`の`Schema`オブジェクト作る
- httpのハンドラ構造体を作って返すようにする
- `web/server.go` で`/query`にハンドラを設定する
- ヒント:
    - 一旦 `attatchLoaderMiddleware` は使わなくても良い

---

# ステップ4 GraphiQLを使ってデバッグ

- `http://localhost:8000/graphiql` にアクセスしてためす

# ステップを繰り返す
- ステップ1 - 4 を繰り返して実装を増やしていく

---

# オプション課題 パフォーマンスの改善

- loaderを実装して、`resolver`から呼び出そう
- ヒント:
    - いきなり`loader`を使った実装をするのはおすすめしない
    - 素朴な実装が完成したあと取り組もう
    - Intern-Bookmarkの設計を参考にしよう
    - できたらすごい

---

# オプション課題 ページング
- 記事の一覧をページングできるように改良しよう
- `bookamarks(page:3)` のように呼び出すイメージ
- ヒント:
    - ひまだったらやろう
    - [Relay](https://facebook.github.io/relay/docs/en/graphql-server-specification.html)形式でやれるとかっこいい

---

# 課題 Webpackの設定をする
- 明日に備えてWebpackを起動できるようにしておこう

---

# ステップ1 TypeScriptのファイルを置く
- 動作確認のために基本的なTypeScriptのコードを置いておこう
- Intern-Bookmarkの以下のファイルを使うと良い
  - `ui/src/index.ts`
  - `ui/src/hello.ts`
- `ui/src/spa.tsx` も置いておこう
  - この中身は明日実装する

---

# ステップ2 webpack.conf.js を書く
- Intern-Bookmark の `ui/webpack.config.js` を同じ場所にコピーして調整しよう
    - 中身の簡単な解説
    - [Webpackのドキュメント](https://webpack.js.org)も参考に
- `docker-compose run --rm --no-deps node yarn watch` して起動するのを確かめよう
    - `static/index.js` が生成されたらOK

---

# おわり
