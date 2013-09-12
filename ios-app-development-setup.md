# iOS アプリ開発環境のセットアップ

iOS アプリ開発に必要な環境をセットアップします。

- OS X
- Developer Account
- Xcode
- Command Line Tools
- iOS Developer Program
- 実機

## OS X

なるべく最新の OS X 環境が必要です。現在は 10.7.4 以降が必要とされています。

OS X 以外の OS では基本的に開発できません。諦めましょう。

## Developer Account

Apple ID を [Apple Developer Center](https://developer.apple.com/) に開発者として登録する必要があります。

## [Xcode](https://developer.apple.com/xcode/index.php)

Apple 製の IDE です。Interface Builder を内包し、iOS / OS X アプリ開発に必要なおよそ一通りの機能を備えます。Objective-C は記述が比較的冗長になりがちなため、IDE の自動補完が役に立ちます。

Xcode は [Mac App Store からダウンロード](https://itunes.apple.com/jp/app/xcode/id497799835?mt=12)します。また Beta 版の iOS などに向けてアプリをつくりたいときは、[iOS Developer Center](https://developer.apple.com/devcenter/ios/index.action) から Developer Preview をダウンロードします。Developer Preview の Xcode では GM リリースになるまで App Store に提出するアプリをつくることができません。通常は Mac App Store のリリース版の Xcode を使います。

### Xcode 以外の開発環境

通常 Xcode 以外の開発環境を使うことはないと思いますが、人によっていろいろあると思いますので、ここに言及します。Xcode 以外のエディタを使うことはできますが、Interface Builder の多くの機能など、Xcode でしか使えない機能が非常に多くあります。このため、Xcode 以外の環境を追い求めたとしても、結局 Xcode と行き来することになるでしょう。

#### [AppCode](http://www.jetbrains.com/objc/)

IntelliJ IDEA などで有名な [JetBrains](http://www.jetbrains.com) 製の有償 IDE です。強力な Xcode という感じで使うことができます。またカスタマイズも柔軟にできるので、手に馴染むように調整できます。

#### Emacs or Vim

Emacs や Vim で Objective-C を書くこともできますが、ここでは紹介しきれないので割愛します。逆に Xcode のキーバインドや使い勝手を Emacs や Vim に近づけるアプローチもあります。これも割愛します。

#### 雑談

いろいろあると思いますが、特に今回は時間も少ないので、最初は諦めて Xcode を使うのがよいのではないでしょうか。コード補完や統合されたドキュメントなど、便利なことも多いはずです。また自動的にエラーを表示し、さらにその修正の提案までしてくれるので、大きな助けになります。

## Command Line Tools

Xcode の環境設定からインストールします。また [Developer Center から単独でダウンロード](https://developer.apple.com/downloads/index.action)することもできます。これらはコンパイラなど、開発に最低限必要な CUI のツールです。

## iOS Developer Program

アプリを実機インストールしたり、実際に App Store で販売したりするためには iOS Developer Program への加入が必要です。¥8,400/年と有償です。これがなくてもシミュレータまででの起動は可能です。今回は、はてなで加入している Enterprise アカウントを使う予定です。Enterprise アカウントは App Store からアプリをリリースしたりはできませんが、企業内で使用するアプリなどのためのアカウントで、はてなでは社内テストなどに利用しています。

## 実機

実機インストールするためにはもちろん実機が要ります。iPhone, iPod touch, iPad などの iOS 端末が必要です。持っていない場合は会社の検証用端末を貸し出しますので、申し出てください。



<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/2.1/jp/"><img alt="クリエイティブ・コモンズ・ライセンス" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/2.1/jp/88x31.png" /></a><br />この 作品 は <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/2.1/jp/">クリエイティブ・コモンズ 表示 - 非営利 - 継承 2.1 日本 ライセンスの下に提供されています。</a>