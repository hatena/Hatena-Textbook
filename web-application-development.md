# Web開発の基礎

# HTTPとURI

- Webアプリに入る前のウォーミングアップです
- 知ってる人は聞き流してください
- Webの基本になる２つの技術
    - HTTP
    - URI


## HTTP

- HTTP (Hypertext Transfer Protocol)
- 中身はテキストで書かれたヘッダと(あれば)ボディ
- リクエストとレスポンス


## リクエストとレスポンスの例

curl -v を使うと中身が見られます。

```
curl -v http://hatenablog.com/
```

リクエスト
```
> GET / HTTP/1.1
> User-Agent: curl/7.35.0
> Host: hatenablog.com
> Accept: */*
```

レスポンス
```
< HTTP/1.1 200 OK
< Cache-Control: private
< Content-Type: text/html; charset=utf-8
< Date: Fri, 17 Jul 2015 10:03:42 GMT
< P3P: CP="OTI CUR OUR BUS STA"
< Server: nginx
< Vary: Accept-Encoding
< Vary: Accept-Language, Cookie, User-Agent
< X-Content-Type-Options: nosniff
< X-Dispatch: Hatena::Epic::Global::Index#index
< X-Frame-Options: DENY
< X-Page-Cache: hit
< X-Revision: b4418f9710e3db5110634da7c553c907
< X-Runtime: 0.026343
< X-XSS-Protection: 1
< transfer-encoding: chunked
< Connection: keep-alive
<
<!DOCTYPE html>
<html
  lang="ja"
  data-avail-langs="ja en"

...以下略
```

- **ステートレス**
    - 基本的にサーバはクライアントの状態に関する情報を保存しない
- メソッドが10程度しかないシンプルなプロトコル
    - シンプル故に実装が簡単
    - シンプル故に広く普及
- メソッド `GET`, `HEAD`, `PUT`, `POST`, `DELETE`, `OPTIONS`, `TRACE`, `CONNECT`, `PATCH`, `LINK`, `UNLINK`
- Webアプリに必要なのはだいたい `GET`, `HEAD`, `PUT`, `POST`, `DELETE` くらい


## その中でも

- 日常的によく使うのは `GET` と `POST`
- `GET`
    - リソースの取得
    - パラメータはURIに入れる
        - http://example.com/bookmark?id=1
- `POST`
    - リソースの作成、変更、削除
    - 変更、削除は本来なら`PUT`, `DELETE`メソッドでやるべき
    - HTMLのformが`GET`/`POST`しかサポートしないため`POST`で代替するのも一般的
    - パラメータはURIとは別でボディに入れる
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
- **URIは名詞である**
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


----


# Webアプリケーション概説

## Webアプリケーションの基本
- 動的なWebページを作りたい
    - ユーザに合わせたページ
    - ユーザがコンテンツを作成できる
    - などなど
- 基本的な動作
    - リクエストから何らかの表現(HTML等)を動的に作ってレスポンスを返す


## Webアプリケーションの構成要素
- 構成要素
    - Web server
    - Web Application Framework (WAF)
    - Web Application (実際のコード)
- このあたりが組み合わさって一つのWebアプリケーションができる


## Webアプリケーションの動作

### 最もシンプルな図

![](http://cdn-ak.f.st-hatena.com/images/fotolife/s/shiba_yu36/20120712/20120712135243.png)

- 動作
    - サーバが*クライアントから*HTTPリクエストを受けとる
    - サーバが*クライアントに*HTTPレスポンスを返す


### サーバとアプリケーションを分離した図

![](http://cdn-ak.f.st-hatena.com/images/fotolife/s/shiba_yu36/20120712/20120712135244.png)

- 追加された動作
    - アプリケーションが*サーバから*サーバリクエストを受けとる
    - アプリｰションが*サーバに*サーバレスポンスを返す
- Webサーバプログラム
    - Apache, nginx, lighttpd, Tomcat, Jetty, Starlet, Unicorn, ...
- サーバリクエスト、サーバレスポンスはサーバのインターフェイス依存
    - 古くは mod_perl, FastCGI など
    - 最近は言語ごとにサーバとアプリケーションの仕様がある
        - Java : Java Servlet
        - Perl : PSGI ([おまけ1][perl-psgi]参照)
        - Python : WSGI
        - Ruby : Rack
    - インタフェースが一致すればアプリケーションはそのままにサーバ実装を入れ替えられる


### WAFとWebアプリケーション処理を分離した図

![](http://cdn-ak.f.st-hatena.com/images/fotolife/s/shiba_yu36/20120712/20120712135245.png)

- 追加された動作
    - WAFが*サーバから*サーバリクエストを受けとる
    - Webアプリケーション処理がWAFからリクエストオブジェクトを受けとる
    - Webアプリケーション処理がWAFにレスポンスオブジェクトを返す
    - WAFが*サーバに*サーバレスポンスを返す
- WAF
    - サーバとの対話を仲介、抽象化する
    - Webアプリケーションを記述するためのユーティリティを提供する
- Webアプリケーション処理
    - ビジネスロジック、DBアクセス、HTML生成など
    - **WAFがあることで処理の記述に専念できる**



## ここまでのまとめ

- WebアプリケーションはHTTPリクエストに対し、動的にHTTPレスポンスを返す
- サーバ側はWebサーバ、WAF、Webアプリケーション処理に分けられる
- WAFを使えばWebアプリケーション処理の実装に集注できる


# MVC

- 先ほどのWebアプリケーション処理の実装のパターンを解説します


## MVC

- Model, View, Controller
    - 表現とロジックを分離
        - デザイナーとエンジニアの作業分担を促進
        - テストがしやすくなる
    - GUIプログラミング、Webアプリケーション


## WebアプリケーションのMVC

![](http://cdn-ak.f.st-hatena.com/images/fotolife/s/shiba_yu36/20130315/20130315114505.png)

- Model
    - 定義では : 抽象化されたデータと手続き
    - Webでは : ORマッパやビジネスロジックなど
    - 大規模になってくるとさらに階層化することも多い
        - アプリケーション層, ドメイン層 など (cf. [MMVC][])
    - はてなでは
        - :warning: 「モデル」という言葉は単にデータモデルを表すのに使うことも多いので注意
    - はてなでは (Perl)
        - `Service`, `Model`, `App` などで構成されていることが多い
    - はてなでは (Scala)
        - `service`, `model`, `repository`, `application` などで構成されていることが多い
- View
    - 定義では : リソースの表現
    - Webでは : HTML, JSON, XML, 画像等を生成するもの
    - はてなでは (Perl)
        - [`Text::Xslate`][perl-text-xslate], [`JSON::XS`][perl-json-xs] など
    - はてなでは (Scala)
        - [Twirl][scala-twirl], [JSON4S][scala-json4s] など
- Controller
    - 定義では
        1. ユーザの入力によって処理の流れを決定
        2. ModelのAPIを呼ぶ
        3. Viewに必要なデータを渡す
    - Webでは : Webアプリケーションフレームワーク(の一部)
    - はてなでは (Perl)
        - [`Router::Simple`][perl-router-simple] など
    - はてなでは (Scala)
        - [Scalatra][scala-scalatra], [Play][scala-play] など


## ここまでのまとめ
- MVCとはModel, View, Controllerにより表現とロジックを分離したもの
- 表現とロジックの分離により、デザイナーとエンジニアで作業が分担できる


----


<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/2.1/jp/"><img alt="クリエイティブ・コモンズ・ライセンス" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/2.1/jp/88x31.png" /></a><br />この作品は<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/2.1/jp/">クリエイティブ・コモンズ 表示 - 非営利 - 継承 2.1 日本 ライセンスの下に提供されています</a>。

[perl-psgi]: ./web-application-development-perl.md#psgi

[MMVC]: http://c2.com/cgi/wiki?ModelModelViewController

[perl-text-xslate]: https://metacpan.org/module/Text::Xslate
[perl-json-xs]: https://metacpan.org/module/JSON::XS
[perl-router-simple]: https://metacpan.org/module/Router::Simple
[scala-twirl]: https://github.com/playframework/twirl
[scala-json4s]: https://github.com/json4s/json4s
[scala-scalatra]: http://scalatra.org/
[scala-play]: https://www.playframework.com/
