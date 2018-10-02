# Webアプリケーション

---

## 目次

- HTTP
- Go言語によるWebアプリケーション
- テスト
- 課題

---

# HTTP

---

## HTTP
URLにアクセスすると降ってくるHTMLをブラウザーが描画する

```
 $ curl http://example.com
<!doctype html>
<html>
<head>
    <title>Example Domain</title>
```

- URLとは？
- 更新・削除: メソッド・リクエストボディ
- 返ってくるもの: レスポンスボディ, HTML, JSON, XML
- 他の様々な情報: リクエストヘッダ・レスポンスヘッダ

---

## HTTP

- Hypertext Transfer Protocol
 - WebブラウザとWebサーバとの間の通信プロトコル
   - リクエストとレスポンスのデータの形に関する決まりごと

参考文献: [Real World HTTP - 歴史とコードに学ぶインターネットとウェブ技術](https://www.google.co.jp/search?q=Real+World+HTTP)

---

## HTTPの歴史
HTTP/0.9 (1991年) GETのみ・ステータスコードもない

HTTP/1.0 (1996年5月) メソッド・レスポンスヘッダ・ステータスコード

HTTP/1.1 (1997年1月) Hostヘッダ・新しいメソッド

HTTP/2 (2015年5月) 接続の多重化・ヘッダ圧縮・パイプライン化

---

## RFC
Request For Comment: 主にインターネットのプロトコルやデータフォーマットに関する技術仕様

HTTP: The Hypertext Transfer Protocol (HTTP) is a stateless application-level protocol for distributed, collaborative, hypertext information systems. (RFC7230)

IETF (The Internet Engineering Task Force) という団体が管理している

---

## Eメール
RFC822 (1982年8月): メールのプロトコルはHTTPよりも古い

RFC2822 (2001年4月): 改定

HTTPプロトコルの元祖

ヘッダ

- `From`, `Sender`, `To`, `Received`
- `Message-Id`, `In-Reply-To`
- `MINE-Version`, `User-Agent`, `Content-Type`

---
### Eメールの例

```
Delivered-To: sample@example.com                              # Headers
Received: from ....example.com (....example.com. [...])
        by ...
        for <sample@example.com>;
        Mon, 30 Jul 2018 20:48:15 -0700 (PDT)
Received: from ....mailgun.net (....mailgun.net [...]) by ....example.com
        <sample@example.com>; Tue, 31 Jul 2018 12:48:14 +0900 (JST)
Sender: support@example.com
Date: Tue, 31 Jul 2018 03:48:13 +0000 (UTC)
From: example Support <support@example.com>
To: sample@example.com
Message-Id: <abcde.15330@postal.example-www>
Subject: Hello, John.
Mime-Version: 1.0
User-Agent: postal/2.0.2
Content-Type: text/plain; charset=utf-8

Hey John,                                                     # Body
```

ヘッダ + 本文 という形はHTTPに引き継がれている

---

## HTTP概要

- HTTPリクエスト
  - メソッド
  - パス
  - ヘッダ
  - ボディ
- HTTPレスポンス
  - ステータスコード
  - ヘッダ
  - ボディ

---

### 例
```
 $ curl -v http://example.com/
*   Trying 93.184.216.34...
* TCP_NODELAY set
* Connected to example.com (93.184.216.34) port 80 (#0)
> GET / HTTP/1.1
> Host: example.com
> User-Agent: curl/7.54.0
> Accept: */*
>
```

---

### 例
```
< HTTP/1.1 200 OK
< Accept-Ranges: bytes
< Cache-Control: max-age=604800
< Content-Type: text/html
< Date: Sun, 05 Aug 2018 11:21:44 GMT
< Etag: "1541025663"
< Expires: Sun, 12 Aug 2018 11:21:44 GMT
< Last-Modified: Fri, 09 Aug 2013 23:54:35 GMT
< Server: ECS (oxr/83C5)
< Vary: Accept-Encoding
< X-Cache: HIT
< Content-Length: 1270
<
<!doctype html>
<html>
<head>
    <title>Example Domain</title>
```

---

## HTTPリクエスト
- メソッド
- パス
- ヘッダ
- ボディ

---

## URL (RFC1738, 1808)
Uniform Resource Locator: リソースの住所, アドレス

- 例: [http://www.example.com:80/index.html?id=sample#foo=bar](http://www.example.com:80/index.html?id=sample#foo=bar)
 - スキーム: `http`, `https`, `mailto`, `file`, `telnet`
 - ホスト名: `www`
 - ドメイン名: `example.com`
 - ポート番号: `:80` (`http`), `:443` (`https`)
 - パス: `index.html`
 - クエリ文字列: `?id=sample`
 - フラグメント `#foo=bar`

---

### URLのエンコーディング
- Percent-Encoding
  - スペースやUTF-8文字などURLで許されない文字をURLで表現するためのエンコーディング
  - 例: https://www.google.com/search?q=%E3%81%BB%E3%81%92%E3%81%BB%E3%81%92
- Punycode: RFC3492
  - ドメイン名で使われるエンコーディング
  - 例: https://xn--url-883bvcubx104b.com/
     - 必ず `xn--` から始まる

---

### URI (RFC3986)
A Uniform Resource Identifier (URI) is a compact sequence of characters that identifies an abstract or physical resource.

URL (Uniform Resource Locator)・URN (Uniform Resource Name) を包含する一般的な概念 (URNは名前でURLは住所)

URLとURIは区別されていたが、W3Cによるともう気にしなくてよい

- ref: [https://url.spec.whatwg.org](https://url.spec.whatwg.org)
- Go・Python・Node.jsはURL, Ruby・C#はURI

---

### URIの例 (RFC3986)
- ftp://ftp.is.co.za/rfc/rfc1808.txt
- http://www.ietf.org/rfc/rfc2396.txt
- mailto:John.Doe@example.com
- tel:+1-816-555-1212
- telnet://192.0.2.16:80/
- urn:oasis:names:specification:docbook:dtd:xml:4.1.2 (URN)

---

## リクエストメソッド (RFC7231)
The request method token is the primary source of *request semantics*; ...

同じリソースに対して異なるメソッドを使うことで様々な操作を表すことができる

- `GET`: リソースを転送する
- `HEAD`: ヘッダのみ要求する
- `POST`: リクエストのペイロードに対してリソース固有の処理を行う
- `PUT`: リクエストのペイロードで対象リソースを置き換える
- `DELETE`: 対象リソースを削除する
- その他: `CONNECT`, `OPTIONS`, `TRACE`

---

## リクエストヘッダ (RFC7231)
- リクエストのコンテキストの情報
  - `Form`, `Referer`, `User-Agent`
- 対象リソースの状態に基づいてリクエストを切り替える
  - `If-Match`, `If-Modified-Since`, 304 Not Modified (RFC7232)
- レスポンスのフォーマット
  - `Accept-Charset`, `Accept-Encoding`, `Accept-Language`
- 認証情報
  - `Authorization` (RFC7235)

---

## リクエストボディ (RFC7231)
- リクエスト・メッセージ、ペイロード
- データの新規作成・更新
- データ形式
  - HTMLフォーム: `multipart/form-data`, `x-www-form-urlencoded`
  - JSON: `application/json`
  - XML: `application/xml`

---

## HTTPレスポンス
- ステータスコード
- ヘッダ
- ボディ

---

## ステータスコード (RFC7231)
レスポンスの意味を表す三桁の数字: 一桁目で分類

- `1xx` `Informational`: リクエスト受付・処理を続行
- `2xx` `Successful`: リクエスト受理
- `3xx` `Redirection`: リダイレクト
- `4xx` `Client Error`: リクエストに誤り
- `5xx` `Server Error`: サーバーの処理失敗

---

### 主なステータスコード
- `200`: `OK`
- `303`: `See Other`
- `307`: `Temporary Redirect`
- `400`: `Bad Request`
- `401`: `Unauthorized`
- `403`: `Forbidden`
- `404`: `Not Found`
- `500`: `Internal Server Error`
- `503`: `Service Unavailable`

---

## レスポンスヘッダ (RFC7231)
サーバーの状態や対象リソースの情報を返す

- `Age`, `Cache-Control`, `Expires`
- `Location`
- `Etag`, `Last-Modified`
- `Content-Encoding`, `Content-Type`, `Content-Length`
- `Retry-After`
- `Server`

---

## セキュリティー関連のヘッダ

- `X-XSS-Protection`: XSSに対するフィルター機能を強制
- `X-Frame-Options`: iframeによりアクセスできないように制御
- `X-Content-Type-Options`: `Content-Type`を無視したスクリプトの実行を抑制
- `Content-Security-Policy`: 実行するスクリプトの制限
- `Strict-Transport-Security`: 次回以降httpsでのリクエストを強制

---

## レスポンスボディ (RFC7231)
リクエストに対応するリソースの内容や、処理の結果を返す。

- HTML文章
- JSON
- XML

---

### HTTPリクエスト
```
GET / HTTP/1.1                    # Request line
Host: example.com                 # Headers
Accept: */*
```

---

### HTTPリクエスト
```
POST /post HTTP/1.1               # Request line
Host: httpbin.org                 # Headers
Content-Type: application/json
Content-Length: 21

{ "sample": "hello" }             # Body
```

---

### HTTPレスポンス

```
HTTP/1.1 200 OK                   # Status line
Cache-Control: max-age=604800     # Headers
Content-Type: text/html
Date: Sun, 05 Aug 2018 12:58:22 GMT
Server: ECS (oxr/8313)
Content-Length: 1270

<!doctype html>                   # Body
<html>
<head>
    <title>Example Domain</title>
```

---

## 認証

---

### HTTPプロトコルは状態を持たない
リクエストとレスポンスの形や解釈の仕方

状態を持たないプロトコルの上で、状態を持つように見せかけるにはどうするか

- キャッシュ (`ETag`, `If-None-Match`, 304 Not Modified)
- 認証

---

### Basic認証
`user:password`を`base64`して`Authorization`ヘッダに入れてリクエストする

```
GET /basic-auth/sample/passwd HTTP/1.1
Host: httpbin.org
Authorization: Basic c2FtcGxlOnBhc3N3ZA==

HTTP/1.1 200 OK
Connection: keep-alive
Server: gunicorn/19.9.0
Date: Sun, 12 Aug 2018 15:19:38 GMT
Content-Type: application/json
Content-Length: 49

{
  "authenticated": true,
  "user": "sample"
}
```

---

### Cookie (RFC6265)
状態を持つセッションを管理できるようにする仕組み。

- `Set-Cookie` レスポンスヘッダ
  - サーバーはこのヘッダに情報を乗せる
  - クライアントはこの情報を保存する
  - `Expires`, `Max-Age`, `Domain`, `Path`, `Secure`, `HttpOnly` 属性
- `Cookie` リクエストヘッダ
  - 同じドメインに対するリクエストに、保存している情報をヘッダとして送信する

---

### Cookieを使った認証
- ログイン
  - ユーザーに紐づくトークンを発行し、`Set-Cookie`で返す
  - クライアントはトークンをローカルに保存
- 認証
  - `Cookie`のトークンからユーザーを解決する
  - ユーザーがなかったりトークンが古かったら認証失敗
- ログアウト
  - 値を空、`Expires`を昔にして`Set-Cookie`を返す
  - クライアントは該当トークンを消す

---

### Cookieの注意事項
- HTTPの場合は平文で送受信される
  - `Secure` 属性をつけると、HTTPS接続以外では送信しない
- ユーザーが意図的に閲覧・変更・削除できる
- クライアントは`Set-Cookie`を無視してよい
- 最大容量が4KB

「Cookieの歴史はwebセキュリティーの歴史」

---

### JWT (RFC7519)
- JSON Web Token `/dʒɒt/` (ジョット)
- JSONをエンコードしたURL-safeな署名付きのトークン
- `header.payload.signature`
  - header: 署名アルゴリズム・トークンタイプの `Base64URL`
     - `{ "alg": "HS256", "typ": "JWT" }`
  - payload: 独自の情報+クレーム情報 の `Base64URL`
  - signature: 改竄されていないことを確かめるための署名

---

## HTTP/2 (RFC7540, 7541)
レイテンシの改善を目的とし、GoogleのSPDYプロジェクトをもとに仕様が策定された、HTTPのバージョン

- リクエストとレスポンスの多重化
- ヘッダの圧縮: `HPACK`
- サーバープッシュ
- ストリームの優先順位と重み

---

# Go言語によるWebアプリケーション

---

## Webアプリケーション

- リポジトリ層: `repository`
  - DBとのデータのやり取り
- サービス層: `service`
  - アプリケーションのロジック
- ウェブ層: `web`
  - URLルーティング・認証・テンプレートのレンダリング

---

## リポジトリ層
DBとのデータのやり取り (SQLの詳細は明日)

```go
func (r *repository) FindUserByID(id uint64) (*User, error) {
	var user model.User
	err := r.db.Get(
		&user,
		`SELECT id,name FROM user WHERE id = ? LIMIT 1`,
		id,
	)
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, userNotFoundError
		}
		return nil, err
	}
	return &user, nil
}
```

---

## サービス層
アプリケーションのロジック

- `App` は `Repository` を持つ
- リポジトリの関数を使って処理を記述する

```go
type bookmarkApp struct {
	repo repository.Repository
}

func (app *bookmarkApp) FindUserByID(userID uint64) (*model.User, error) {
	return app.repo.FindUserByID(userID)
}
```

---

## ウェブ層
- ルーティング
- リクエストボディ
- 認証
- テンプレート

---

## ルーティング
URLパスに対して `http.Handler` を登録していく

```go
http.HandleFunc("/hello", func(w http.ResponseWriter, r *http.Request) {
	io.WriteString(w, "Hello, world!\n")
})
```

- [`github.com/dimfeld/httptreemux`](https://github.com/dimfeld/httptreemux)
  - URLの中のパラメータ
  - メソッドのサポート: なければ `405 Method Not Allowed`
  - パスのグルーピング

参考: [https://golang.org/pkg/net/http/](https://golang.org/pkg/net/http/), [https://godoc.org/github.com/dimfeld/httptreemux](https://godoc.org/github.com/dimfeld/httptreemux)

---

## リクエストボディ
HTMLのフォーム (`multipart/form-data`)

```go
func Handler(w http.ResponseWriter, r *http.Request) {
	name, password := r.FormValue("name"), r.FormValue("password")
	if err := app.CreateNewUser(name, password); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
}
```

---

## リクエストボディ
JSON

```go
func Handler(w http.ResponseWriter, r *http.Request) {
	var d SomeData
	if err := json.NewDecoder(r.Body).Decode(&d); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	fmt.Printf("%+v\n", d)
}
```

---

## 認証: Cookie

```go
const sessionKey = "BOOKMARK_SESSION"

func Login(w http.ResponseWriter, r *http.Request) {
	user = ... // name, password を受け取って確認
	expiresAt := time.Now().Add(24 * time.Hour)
	token := app.CreateNewToken(user.ID, expiresAt)
	http.SetCookie(w, &http.Cookie{ Name: sessionKey, Value: token, Expires: expiresAt })
	http.Redirect(w, r, "/", http.StatusSeeOther)
}

func Handler(w http.ResponseWriter, r *http.Request) {
	var user *model.User
	cookie, err := r.Cookie(sessionKey)
	if err == nil && cookie.Value != "" {
		user, _ = app.FindUserByToken(cookie.Value)
	}
	// user: ログイン中のユーザー
}
```

---

## HTMLテンプレート
- テンプレートファイルの読み込みとコンパイル
  - [go-assets-builder](https://github.com/jessevdk/go-assets-builder)でバイナリー埋め込み
- テンプレートの実行
  - テンプレート引数

参考: [https://golang.org/pkg/html/template/](https://golang.org/pkg/html/template/)

---

## テンプレート

```html
{{if .User}}
  ユーザー名: {{.User.Name}}
  <form action="/signout" method="POST">
    <input type="hidden" name="csrf_token" value="{{$.CSRFToken}}">
    <input type="submit" value="ログアウト"/>
  </form>
{{else}}
  <a href="/signup">ユーザー登録</a>
  <a href="/signin">ログイン</a>
{{end}}
```

参考: [https://golang.org/pkg/html/template/](https://golang.org/pkg/html/template/)

---

## ミドルウェア
Webアプリケーションの様々な処理がミドルウェアとして表現できる

- 認証
- リクエスト・レスポンスのログ
- レスポンスヘッダ

玉ねぎの絵が出てくる: [web framework middleware onion](https://www.google.co.jp/search?q=web+framework+middleware+onion&tbm=isch)

---

### ミドルウェア

Go言語では `http.Handler` を受け取って `http.Handler` を返す関数

```go
type MiddlewareFunc func(http.Handler) http.Handler
```

```go
func loggingMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()
		next.ServeHTTP(w, r)
		log.Printf("%s %s took %.2fmsec", r.Method, r.URL.Path,
			float64(time.Now().Sub(start).Nanoseconds())/1e6,
		)
	})
}
```

---

## レイヤーの結合
SQLを発行するのはリポジトリ層の責務である。サービス層が直接SQLを発行できないようにするにはどうすればいいだろうか。

- サービス層はリポジトリの操作を組み合わせて実装したい
  - 「サービス」は「リポジトリ」を持っている？
- リポジトリの具体を知りたくない
  - 接続先がMySQLかどうか・SQLですらないかもしれない

→ 抽象に依存させよ

---

### レイヤーの結合

```go
// 抽象を公開
type Repository interface {
	FindUserByID(id uint64) (*model.User, error)
}

// 非公開
type repository struct {
	db *sqlx.DB
}

func (r *repository) FindUserByID(id uint64) (*model.User, error) {
}

// サービスはinterfaceに依存
type bookmarkApp struct {
	repo Repository
}
```

---

# テスト

---

## テスト

- 書いたコードが意図した挙動をしているか
- コーナーケースが考慮されているか
- 動いてはいけないケースをきちんと弾いているか
- ライブラリーのバージョンを上げても、アプリケーションの挙動が変わらないこと
- 昨日の自分は赤の他人

---

### テストで確認すること

- 正常系
  - 正しい条件で正しく動くこと
- 異常系
  - おかしな条件で正しくエラーを吐くこと
- 境界条件・極端な条件
  - 空の配列、巨大なデータ

---

### テストよもやま話

- 機能試験・性能試験
- ユニットテスト・統合テスト
- カバレッジ
  - 命令網羅: C0
  - 分岐網羅: C1
  - 条件網羅: C2
- TDD (テスト駆動開発)
- Table Driven Test: Go言語で推奨される

参考: [https://ja.wikipedia.org/wiki/ソフトウェアテスト](https://ja.wikipedia.org/wiki/%E3%82%BD%E3%83%95%E3%83%88%E3%82%A6%E3%82%A7%E3%82%A2%E3%83%86%E3%82%B9%E3%83%88)

---

# 課題

---

## Webアプリケーション
日記webアプリケーション go-Intern-Diary のユーザー登録・ログイン機能を作ってください。

- ユーザーに関連するテーブルを作りましょう: `db/`
- リポジトリ層・サービス層を作りましょう: `repository/`, `service/`
  - (オプション) サービス層はテストを書きましょう
- ウェブ層をつくりましょう: `web/`
  - トップページのテンプレートを作り、ブラウザーでアクセスできるようにしましょう
  - ログイン・ログアウト機能を作りましょう
      - `/signup` でユーザー登録できる
      - ログアウトできる
      - `/signin` でログインできる

go-Intern-Bookmarkのコピペでよいですが、コンパイルできることを確認、コミットしながら進めましょう。

---

### オプション課題

- 日記のwebアプリケーションのモデルを考えましょう。
- `X-Frame-Options: DENY` を消すと挙動が変わることを確かめてください。このヘッダをつけていないwebアプリケーションに対する攻撃方法を調べましょう。
- CSRFトークンのinputを消すとどうなるか確認してください。CSRFとは何の略でしょうか。CSRF対策をしていないwebアプリケーションに対する攻撃方法を調べましょう。
- ログインパスワードを安全に保存する方法について調べましょう。bcryptの利点を答えてください。PBKDF2やscryptとの違いを調べましょう。
- セッショントークンをJWTにしてください。JWTが使われているプロトコルについて調べましょう。

---

# 発展研究: HTTP

---

## HTTPの基礎
- `curl -v -I http://httpbin.org` を試してみよう。
- リクエストメソッド、URL、ヘッダ、レスポンスのステータス、ヘッダを確認しよう。
- `-I` を取って試してみよう。
- サーバーで使われている技術についてなにか分かるだろうか。
- `http://b.hatena.ne.jp` や `http://hatena.ne.jp` にリクエストしてみよう。
- `Content-Length`の値は正しいだろうか。

---

## メソッド
- `curl -v http://httpbin.org/post` を実行して、レスポンスの意味を理解しよう。
- このURLに対して200が返ってくるようにするにはどうすればいいだろうか。

---

## リクエストヘッダ
- `http://httpbin.org/headers` にリクエストを送ってみよう。
- `User-Agent`を変更してみよう。

---

## リクエストボディ
- `http://httpbin.org/post` に `name: John`, `age: 20` というデータを `application/x-www-form-urlencoded` で送信してください。
- `{ "name": "John", "age": 20 }` というJSONを送信してください。
- 適当なテキストファイルを添付して `multipart/form-data` で送信してください。

---

## Basic認証
- `http://httpbin.org/basic-auth/sample/passwd` にリクエストを送ってみよう。ステータスコードを調べよう。
- このURLに対して200が返ってくるようにするには、どうすればいいだろうか。`curl`の`-u`オプションを使わずにリクエストしてください。

---

## Cookie
- `curl -v -I http://b.hatena.ne.jp/` を試してみよう。
- `Set-Cookie`に従って`Cookie`ヘッダをつけてリクエストすると何が変わるだろうか。
- Cookieの各属性について調べてみよう。
- Third-party cookieとはどういうものか調べよう。

---

## リダイレクト
- `http://httpbin.org/redirect/1` にリクエストを送ってみよう。ステータスコードの意味や、リダイレクト先について調べてみよう。
- リダイレクトをフォローするcurlのオプションを調べよう。そのオプションをつけるとどうなるだろうか。
- 二回リダイレクトするとどうなるだろうか。
- `Re-using existing connection!` とはどういう意味だろうか。
- 300番台のステータスコードの違いについて調べよう。
  - 308 (RFC7538) の特徴を答えてください。

---

## ブラウザー・telnet
- ブラウザーを使って、リクエストヘッダ、レスポンスヘッダを確認してみよう。
- ブラウザーでCookieを確認してみよう。
- 304ステータスが返ってくるエンドポイントの仕組みを理解しよう。
- `telnet`コマンドを使って、GETやPOSTなど色々なHTTPリクエストを送ってみよう。
  - `Host`ヘッダはなぜ必要なのでしょうか。
  - `httpbin.org`の IPアドレスを `dig` や `whois` で調べてください。どういうことがわかりますか。そのIPアドレスに対して `curl` するとどうなりますか。`Host`ヘッダをつけるとどうなりますか。

---

## HTTP/2
- `example.com` に対してHTTP/1.1とHTTP/2でリクエストしたときの違いを確認しよう。
- ブラウザーでヘッダを見たときになにか気がつくことはあるか。
- ヘッダの圧縮形式 `HPACK` の符号化方式について調べよう。ボディの圧縮に広く使われる `gzip` ではない理由はなぜか。
- ストリーム、メッセージ、フレームの意味を調べよう。
- ストリームの優先順位と重みは何のために必要か。
- HTTP/2によってレイテンシが改善する理由を3つ以上考えよう。
- HTTP/2はHTTP/1.1を置き換えるものではないというのはどういう意味だろうか。
- 仕様が策定された経緯を調べてみよう。
