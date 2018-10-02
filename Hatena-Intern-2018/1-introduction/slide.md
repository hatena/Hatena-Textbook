# イントロダクション

---

# カリキュラム

- 前半: 2週間の講義
  - ウェブサービスにまつわる諸々の学習
- 後半: 実際のチームで開発
  - チームの一員として、いいもの作っていきましょう

---

## 前半1週目

- 月: イントロダクション & 環境セットアップ
- 火: シンプルなウェブアプリケーション
- 水: データベース登場
- 木: API の実装
- 金: フロントエンド

---

## 1日の流れ

- 10:30ごろ 8Fセミナールーム（ここ）に出社しましょう
- 10:30 〜 11:00 当日の準備やアンケート記入
- 11:00 前日の課題の〆切
- 11:00 〜 13:00 講義
- 13:00 〜 14:00 ランチ
- 14:00 〜 19:00 課題!!!
  - この間の何処かで前日の課題の講評があります
  
### 退社前に日報を書こう

- 出社時間
- 退社時間
- 今日やったこと
  - 学んだこと
  - 考えたこと
  - はまったこと
  - 書いたカッコイイコード
  - ランチ情報…などなど

---

## 前半2週目

- 月: 機械学習
- 火: 機械学習
- 水: インフラ & サービス開発 & コミュニティ
- 木: AWS ハンズオン
- 金: 後半配属に向けた準備

課題らしい課題があるのは機械学習まで。がんばりましょう！

2週目のうちに、後半配属チームを決定します

---

# 開発環境

ソフトウェアエンジニアの道具箱。一日中使うので丁寧に整備し、使いこなそう

---

## OS

UNIX 環境（macOS or Linux）が基本

- 開発ツール・ライブラリが揃っている
- アプリケーションサーバに近い環境（はてなでは主に Debian）

---

## ターミナルとシェル

ターミナルは Terminal.app か [iTerm2](https://www.iterm2.com/) がオススメ

OSと人間とのインタフェース。とくにシェルは使いこなせるようになろう

---

`zsh` か `bash` がオススメ。

簡単な使いかただけおぼえとこう:

- `Ctrl-P` `Ctrl-N` でコマンド履歴をたどる
- `Ctrl-R` でインクリメンタル検索
- `Tab` でコマンド補完

---

よく使うコマンド:

- ファイルから文字列を検索
  - `pt` `rg` `git grep` `grep`
- ファイルを検索
  - `fzf` `fd` `find`
- コピペ（macOS のみ）
  - `pbcopy` `pbpaste`

メンターがいろいろ教えてくれるかもしれないぞ!!!

    brew install pt fzf fd

---

## エディタ

[Visual Studio Code](https://code.visualstudio.com/)

社内で共有されているオススメ設定を [VSCode](https://hatenaintern2018.g.hatena.ne.jp/keyword/VSCode) キーワードに書いてます

    brew cask install visual-studio-code

適当なディレクトリで `code .` で VSCode をひらけるぞ

---

## Git

[Git](https://git-scm.com/)

社内の開発は Git ベースです。Git 対応人材になろう

[サルでもわかるGit入門 〜バージョン管理を使いこなそう〜](https://backlog.com/ja/git-tutorial/)

    brew install git

---

## Go

今回の講義は Docker（後述）内で進めるけど、手元にも環境があったほうが何かと便利。

    brew install go

---

### $GOPATH を決めよう

Go 言語であつかうソースコードは決まったディレクトリ以下に配置する必要がある

特にこだわりがなければ `~/go` が自分の GOPATH になります

`go-Intern-Diary` が GOPATH にない場合は `$GOPATH/src/github.com/hatena/go-Intern-Diary` に移動しておこう

---

## ghq

複数のリポジトリを管理してくれるやつです。とりあえず乗っとくと便利

[ghq: リモートリポジトリのローカルクローンをシンプルに管理する](https://motemen.hatenablog.com/entry/2014/06/01/introducing-ghq)
[おい、peco もいいけど fzf 使えよ](https://qiita.com/b4b4r07/items/9e1bbffb1be70b6ce033)

<!-- -->

    brew install ghq

---

# 前半課程の進め方

- [go-Intern-Bookmark](https://github.com/hatena/go-Intern-Bookmark) ... サンプル
- [go-Intern-Diary](https://github.com/hatena/go-Intern-Diary) ... これをつくるよ

---

## 課題の提出は Pull Request

1. 自分の GitHub アカウントに hatena/go-Intern-Diary を fork
2. 課題ごとに、master からブランチを切って作業開始
  - **こまめに commit & push しよう！**
  - ビッグバンコミットは修正しづらい & 読みづらくて 🙅
3. ブランチから master に向けて Pull Request を作る
4. 講師にレビューしてもらう、大きな問題がなければ master にマージ

---

# 環境構築しよう

---

## Homebrew

[brew.sh](https://brew.sh/index_ja)

macOS 用のパッケージマネージャ。
これまで紹介したものに限らず、便利なものはだいたい `brew` で入ります

---

## Docker

[www.docker.com](https://www.docker.com/)

- コンテナ型の仮想化環境
  - 親ホストの環境を汚さずに、アプリケーションのための環境を用意できる
- 前半課程は Docker 上で進めます
  - 後半でも、開発環境が Docker 化されているチームは多い

インストールしよう:

    brew cask install docker

または https://store.docker.com/editions/community/docker-ce-desktop-mac

---

## docker-compose

* 複数の Docker コンテナの生成・起動の管理を簡単にするツール
* 前半課程ではこれ経由で Docker に触れることになります
* 設定の実体は `docker-compose.yaml` というファイル

---

# ウォームアップ: go-Intern-Bookmark を起動してみよう

---

## docker-compose up

    cd go-Intern-Bookmark
    docker-compose up

ログが流れてくる...

    Starting go-intern-bookmark_db_1   ... done
    Starting go-intern-bookmark_node_1 ... done
    Starting go-intern-bookmark_app_1  ... done

このターミナルはログ専用になります。

落ち着いたら http://localhost:8000/ にアクセス

---

## docker-compose ps

別のターミナルから（同じディレクトリで）:

    docker-compose ps --services

こうなってますか？

    db
    app
    node

"app", "db", "node" の 3 つのサービス（のプロセス）が起動し、これらでひとつのウェブサービス（の開発環境）が形成されている。

---

`docker-compose ps` してみると:

              Name                        Command             State           Ports
    ----------------------------------------------------------------------------------------
    go-intern-bookmark_app_1    ./build/server                Up      0.0.0.0:8000->8000/tcp
    go-intern-bookmark_db_1     docker-entrypoint.sh mysqld   Up      0.0.0.0:3306->3306/tcp
    go-intern-bookmark_node_1   yarn watch                    Up

---

## docker-compose exec

以下のコマンドを打ってみよう:

    docker-compose exec db mysql

"db" サービスで `mysql` コマンドを実行する、の意。

こんなふうに、MySQL のプロンプトが表示されますか？

    Welcome to the MySQL monitor.  Commands end with ; or \g.
    Your MySQL connection id is 4
    Server version: 5.7.22 MySQL Community Server (GPL)

    Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

    Oracle is a registered trademark of Oracle Corporation and/or its
    affiliates. Other names may be trademarks of their respective
    owners.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

    mysql>

ここでさらに以下を入力してみよう:

    mysql> SHOW DATABASES;

こんなふうに、データベースが一覧できましたか？

    +----------------------+
    | Database             |
    +----------------------+
    | information_schema   |
    | intern_bookmark      |
    | intern_bookmark_test |
    | mysql                |
    | performance_schema   |
    | sys                  |
    +----------------------+
    6 rows in set (0.01 sec)

満足したら `Ctrl-D` でプロンプトを抜けましょう。

---

## 止める

* `docker-compose up` したターミナルで `Ctrl-C`、または
* `docker-compose stop`
* もう一度起動したいときはまた `docker-compose up`

---

# 課題: hatena/go-Intern-Diary に PR

* go-Intern-Diary の自分の master から適当な名前（`day-1` など）でブランチを切る
* `README.md` に適当に追記して `git commit` & `git push`
* GitHub 上で Pull Request を作成する
