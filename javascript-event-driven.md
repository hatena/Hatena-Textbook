#  アジェンダ

*  JavaScript の言語について
*  DOM について
*  イベントについて
*  jQuery について
*  MVC アーキテクチャについて

#  まずはじめに

##  <span lang="en">Just moment!</span>
*  Web で JS を使うとき、HTML の知識が前提となることが多い
  *  http://www.kanzaki.com/docs/htminfo.html
    *  少なくとも「簡単なHTMLの説明」は押さえておきたい。

##  目的

講義時間は限られているので

*  JS を学ぶ上でとっかかりをつかめること
  *  リファレンスを提示します。概念を理解
*  言語的部分、DOM 及びイベントドリブンなプログラミング

覚えようとするとクソ多いのでリファレンスひける部分は覚えない

##  JS とはどんな言語であるか?

*  基本クライアントサイド=ブラウザで動く
  *  実装がたくさんある
*  はてなのエンジニアはみんな誰もがある程度書けます
  *  ウェブアプリを書く上で必須なため
*  フロントエンドの重要性

##  先に JS のデバッグ方法

*  デバッガ
  *  Firefox なら Firebug、Google Chrome ならデベロッパー ツール
  *  スクリプトを中断する場所 (ブレークポイント) を指定でき、そこから1行ずつ実行できる
  *  スクリプト中に <code>debugger;</code> と書いておけばそこで中断する
*  <code>console.log()</code>
  *  ブロックせずにコンソール領域へ直接出力
  *  他言語の print デバッグに相当する
  *  最近のブラウザでは標準でサポートされつつある
*  <code>document.title</code>
  *  view-source:http://ma.la/files/shibuya.js/dec.html
  *  <code>console.log()</code> が一般的でなかったころ
*  <code>alert()</code>
  *  古典的だが今でも役に立つこともある
  *  その時点で処理がブロックするので、ステップをひとつずつ確認するとき便利

*  これらを仕込んで、リロードしまくることで開発します
  *  エラーコンソールをどうやって開くかからはじめましょう

##  クロスブラウザについて

ここでクロスブラウザについて覚えても仕方ないので、Firefox と Firebug で開発することを前提にします。

#  JavaScript 言語について

##  言語的特徴

*  変数に型なし
  *  プリミティブな型 + オブジェクティブな型
  *  ただしプリミティブ型も自動的にオブジェクティブ型へ変換される
*  関数はデータとして扱える (オブジェクト)
*  文法は C に似てる
*  言語的な部分は<a href="http://www2u.biglobe.ne.jp/~oz-07ams/prog/ecma262r3/">ECMAScript として標準化</a>されている
  *  ActionScript も同じ。AS やったことあるなら JS は DOM さえ覚えれば良い
*  プロトタイプ指向なためクラスというものはない
  *  クラス指向を模倣することはできる

ひとつずつ説明していきます

##  変数に型なし

Perl と一緒で、Java や C などと違う点


``` javascript
var foo = "";
foo = 1;
foo = {};
```

文字列を入れた変数にあとから数値を入れたりオブジェクトを入れられる

値自体には当然ちゃんと型があります

##  JSの型

*  <code>undefined</code>
*  <code>null</code>
*  <code>number</code>
*  <code>boolean</code>
*  <code>string</code>
*  <code>object</code>
  *  <code>({})</code>
  *  <code>[]</code>

<code>number</code>, <code>boolean</code>, <code>string</code> とかは<a href="http://www2u.biglobe.ne.jp/~oz-07ams/prog/ecma262r3/9_Type_Conversion.html">プリミティブ値</a>と呼ばれます

オブジェクト以外はプリミティブです。

##  JSの型 - <code>typeof</code>

<a href="http://www2u.biglobe.ne.jp/~oz-07ams/prog/ecma262r3/11_Expressions.html#section-11.4.3"><code>typeof</code> 演算子</a>で調べることができます


``` javascript
typeof undefined;
typeof 0;
typeof true;
typeof {};
typeof [];
typeof null;
typeof "";
typeof new String("");
typeof alert;
```

それぞれどれになるでしょう?

<code>"undefined"</code>, <code>"number"</code>, <code>"boolean"</code>, <code>"string"</code>, <code>"object"</code>


##  JSの型 - <code>typeof</code>


``` javascript
typeof undefined //=> "undefined"
typeof 0;        //=> "number"
typeof true;     //=> "boolean"
typeof "";       //=> "string"
typeof {};       //=> "object"
typeof [];       //=> "object"
typeof null;     //=> "object"
typeof new String(""); //=> "object"
typeof alert;    //=>"object"
```

##  JS の型、object 型

*  <code>Array</code> や <code>RegExp</code> など
*  <code>string</code>, <code>number</code> をラップする <code>String</code>, <code>Number</code>
*  <code>Function</code>

プリミティブ型からオブジェクト型へは自動変換がかかります (<code>null</code>, <code>undefined</code> 以外)


``` javascript
"foobar".toLowerCase();
```

としたとき、<code>"foobar"</code> は <code>string</code> プリミティブであるにも関わらず、メソッドを呼べるのはメソッドを呼ぼうとしたときに自動的に <code>String</code> オブジェクトへ変換されるからです。


``` javascript
new String("foobar").toLowerCase();
```

とはいえ大抵はオブジェクトへの変換を気にする必要はありません。

##  <code>object</code> 型

そもそもオブジェクト型って何かというと、名前と値のセット (プロパティ) を複数持ったものです。

連想配列とかハッシュとか言えばだいたい想像できると思います。


``` javascript
var obj = {}; // オブジェクトリテラル記法。new Object() と同じ
obj['foo'] = 'bar'; // foo という名前に 'bar' という値をセットしている。
obj.foo = 'bar'; // これも上と全く同じ意味
```


``` javascript
var obj = {
   foo : 'bar'
};
```

配列もJSではオブジェクトとして扱えます。

##  <code>undefined</code> と <code>null</code>


``` javascript
var foo;
typeof foo; //=> undefined
```

未定義値。


``` javascript
var foo = null
typeof foo; //=> object
```

何も入ってないことを示す

(<code>object</code> が入っていることを示したいが空にしときたいとか)


##  関数はデータ

JS では関数もデータになれ、<code>Function</code> オブジェクトのインスタンス扱いです。(第一級のオブジェクトというやつです)

変数に代入でき、引数として関数を渡すことが可能です。


``` javascript
var fun = function (msg) {
	alert(arguments.callee.bar + msg);
};
// object なので
fun.bar = 'foobar';

fun();
```

##  関数はデータ (2)

JS では関数もデータになれ、<code>Function</code> オブジェクトのインスタンス扱いです。(第一級のオブジェクトというやつです)

変数に代入でき、引数として関数を渡すことが可能です。


``` javascript
var fun = function (callback) {
	alert('1');
	callback();
	alert('3');
};
fun(function () {
	alert('2');
});
```

##  関数の定義


``` javascript
function foobar() {
}
```

と


``` javascript
var foobar = function () {
};
```

はほぼ同じです (呼べるようになるタイミングが違います)

##  関数: <code>arguments</code>


``` javascript
function foobar() {
	alert(arguments.callee === foobar); //=> true
	alert(arguments.length); //=> 2
	alert(arguments[0]);     //=> 1
	alert(arguments[1]);     //=> 2
}
foobar(1, 2);
```


##  変数のスコープ

関数スコープです。<code>for</code> などのループでスコープを作らないことに注意


``` javascript
function (list) {
	for (var i = 0, len = list.length; i < len; i++) {
		var foo = list[i];
	}
}
```

は以下と同じ


``` javascript
function (list) {
	var i, len, foo;
	for (i = 0, len = list.length; i < len; i++) {
		foo = list[i];
	}
}
```

##  変数のスコープ：ハマりポイント


``` javascript
var foo = 1;
(function () {
	alert(foo); //=> undefined
	var foo = 2;
	alert(foo); //=> 2
})();
```

は以下と同じ


``` javascript
var foo = 1;
(function () {
	var foo = undefined;
	alert(foo); //=> undefined
	foo = 2;
	alert(foo); //=> 2
})();
```

##  小ネタ: 配列的なオブジェクトを配列にする


``` javascript
var arrayLike = {
  '0' : 'aaa',
  '1' : 'bbb',
  '2' : 'ccc',
  '3' : 'ddd',
};
arrayLike.length = 4;
var array = Array.prototype.slice.call(arrayLike, 0);
```

<code>Array</code> が持つ関数の多くはレシーバに <code>Array</code> コンストラクタを使って作られたことを要求しない

<code>Array</code> の基本的要件は

*  <code>length</code> プロパティを持っていること
*  数字 (の文字列) を配列の要素のプロパティとして持っていること

<code>arguments</code> や <code>NodeList</code> なども <code>Array</code> ではない <code>Array</code>-like なもの

##  プロトタイプ指向

他のあるオブジェクトを元にして新規にオブジェクトをクローン (インスタンス化) していくオブジェクト指向技術

クラス指向はクラスからしかインスタンス化できないが、プロトタイプ指向ではあらゆるオブジェクトを基に新たなオブジェクトを生成できる

###  メリット

*  柔軟
*  HTML のように個々の要素がほぼ同じだけど微妙に違う場合に便利

###  デメリット

*  自由すぎる


##  JS におけるプロトタイプ

プロトタイプにしたいオブジェクトに初期化関数を組み合せることでオブジェクトをクローンできる


``` javascript
function Foo() { }
Foo.prototype = {
   foo : function () { alert('hello!') }
};

var instanceOfFoo = new Foo();
instanceOfFoo.foo(); //=> 'hello!'
```

##  JS におけるプロトタイプ (プロトタイプチェーン)

<img src="http://cdn-ak.f.st-hatena.com/images/fotolife/c/cho45/20100723/20100723021218.png" />

``` javascript
function Foo() { }
Foo.prototype = {
   foo : function () { alert('hello!') }
};

function Bar() { }
Bar.prototype = new Foo();
Bar.prototype.bar = function () { this.foo() };

var instanceOfBar = new Bar();
instanceOfBar.bar(); //=> 'hello!'
```

*  新規に作られたオブジェクトは自身のプロトタイプへの暗黙的な参照を持っている
*  プロトタイプにしたいオブジェクトに初期化関数を組み合せることでオブジェクトをクローンできる
*  暗黙的参照は既定オブジェクトである <code>Object</code> まで暗黙的な参照を持っている
  *  => プロトタイプチェイン

プロトタイプチェーンは長くなると意味不明になりがちなので、あんまりやらないことが多い気がします。(継承やりすぎると意味不明なのがひどくなった感じです)

##  <code>this</code> について

*  <code>this</code> という暗黙的に渡される引数のようなものがあります
*  Perl の <code>$self</code> みたいなやつです
*  普通はレシーバーが渡されます
  *  <code>foo.bar()</code> の <code>foo</code> のことをレシーバといいます
*  明示的に渡せすこともできる (<code>apply</code>, <code>call</code>)


``` javascript
var a = { foo : function () { alert( a === this ) } };
a.foo(); //=> true
a.foo.call({}); //=> false
```

##  JS の使われかた

*  HTML の
*  <code>script</code> 要素で


``` html
<!DOCTYPE html>
<title>JS test</title>
<script type="text/javascript" src="script.js"></script>
```

##  JS については以上です

質問など

*  変数に型なし
*  関数はデータとして扱える (オブジェクト)
*  プロトタイプ指向
*  文法的に
*  そもそも?

(あとで書いてみると疑問になることが多いと思うので聞いてください)

#  DOM について

##  DOM とは

*  Document Object Model の略です
*  HTML とか CSS を扱うときの API を定めたものです
*  ブラウザはDOM APIをJSで扱えるようにしています
*  DOM にはレベルというものがあります
  *  DOM Level 0 =  標準化されてなかったものの総称
  *  DOM Level 1 = とても基本的な部分 (Element がどーとか)
  *  DOM Level 2 = まともに使える DOM (Events とか)
  *  DOM Level 3 = いろいろあるが実装されてない

今は高レベルの DOM といえそうなものでは、HTML5 として仕様が策定されていたりする

DOM Level 0 の多くも HTML5 で標準化されている

##  DOM の基本的な考えかた

<img src="http://cdn-ak.f.st-hatena.com/images/fotolife/c/cho45/20100721/20100721183313.png" />

一番上にはドキュメントノード (文書ノード)

##  DOM の構成要素

*  <code>Node</code>
  *  全ての DOM の構成要素のベースクラス
*  <code>Element</code>
  *  HTML の要素を表現する
*  <code>Attr</code>
  *  HTML の属性を表現する
*  <code>Text</code>
  *  HTML の地のテキストを表現する
*  <code>Document</code>
  *  HTML のドキュメントを表現する
*  <code>DocumentFragment</code>
  *  文書木に属さない木の根を表現する

<code>Text</code> も <code>Attribute</code> も <code>Node</code> のうちです。これらがツリー構造 (文書木) になっています。

##  よく使うメソッド

*  <code>document.createElement('div')</code>
  *  要素ノードをつくる 
*  <code>document.createTextNode('text')</code>
  *  テキストノードをつくる
*  <code>element.appendChild(node)</code>
  *  要素に子ノードを追加する
*  <code>element.removeChild(node)</code>
  *  要素の子ノードを削除する
*  <code>element.getElementsByTagName('div')</code>
  *  指定した名前をもつ要素を列挙
*  <code>document.getElementById('foo')</code>
  *  指定したIDをもつ要素を取得
*  <code>node.cloneNode(true);</code>
  *  指定したノードを子孫ノード込みで複製

*  https://developer.mozilla.org/en/DOM/element
*  https://developer.mozilla.org/en/DOM/document

##  例えばテキストノードを要素に追加する場合


``` html
<div id="container"></div>
```

+


``` javascript
var elementNode = document.createElement('div');
var textNode    = document.createTextNode('foobar');
elementNode.appendChild(textNode);

var containerNode = document.getElementById('container');
containerNode.appendChild(elementNode);
```

↓


``` html
<div id="container"><div>foobar</div></div>
```

*  ブラウザの画面に表示されるのは文書木に属するノード
*  ノードを作った段階では、そのノードはまだ文書木に属していない

##  空白もノードです


``` html
<div id="sample">
<span>foobar</span>
</div>
```


``` javascript
alert(document.getElementById('sample').firstChild); //=> ?
```


##  続きはリファレンスで

言語的な部分は仕様を読むのが正確でてっとりばやい(和訳あるし)

*  http://www2u.biglobe.ne.jp/~oz-07ams/prog/ecma262r3/

ちょい読んでみましょう

##  続きはリファレンスで (2)

DOM 的な部分は Mozilla Developer Center がよくまとまっている(部分的に和訳ある)

*  https://developer.mozilla.org/En

DOM も仕様を読むのは参考になる (和訳あり)

*  http://www2u.biglobe.ne.jp/~oz-07ams/prog/

#  イベント

##  並列性

*  JS に並列性はない・組み込みのスレッドはない
*  同時に処理されるコードは常に1つ
  *  1つのコードが実行中だと他の処理は全て<strong>止まる</strong>ということ
*  多くのブラウザはループ中スクロールさえできない
  *  Opera 10.60 では止まらないようになっている

##  非同期プログラミング

待たない/待てないプログラミングのこと

*  待てないのでコールバックを渡す
*  待てないのでイベントを設定する (方法としてはコールバック)
*  待たないので他の処理を実行できる

##  イベント

JS で重要なのは「イベント」の処理方法です。

JS では非同期プログラミングをしなければなりません。

##  イベントドリブン

*  JS ではブラウザからのイベントをハンドリングします

###  メリット

*  同時に2つのコードが実行されないので同期とかがいりません
  *  変数代入で変に悩まなくてよい
*  イベントが発火するまで JS レベルでは一切 CPU を食わない

###  デメリット

*  1つ1つの処理を最小限にしないと全部止まります
  *  JS関係は全て止まります
  *  ブラウザUIまで止まることが多いです
*  コールバックを多用するので場合によっては読みにくい
  *  あっちいったりこっちいったり

##  イベントの例

*  <code>setTimeout(callback, time)</code>
  *  一定時間後にコールバックをよばせる
  *  (非同期。DOM Events ではない)
*  <code>element.addEventListener(eventName, callback, useCapture)</code>
  *  あるイベントに対してコールバックを設定する
  *  イベントはあらかじめ定められている

##  <code>setTimeout</code>


``` javascript
setTimeout(function () {
    alert('2');
}, 100);
alert('1');
```
https://developer.mozilla.org/ja/DOM/window.setTimeout

##  <code>addEventListener</code>


``` javascript
document.body.addEventListener('click', function (e) {
    alert('clicked!');
}, false);
```
https://developer.mozilla.org/ja/DOM/element.addEventListener

##  イベントの例

*  <code>mousedown</code>
*  <code>mousemove</code>
*  <code>mouseup</code>
*  <code>click</code>
*  <code>dblclick</code>
*  <code>load</code>

などなど。いっぱいあります。http://esw.w3.org/List_of_events

##  イベントバブリング


``` html
<p id="outer">Hello, <span id="inner">world</span>!</p>
```

*  <code>inner</code> をクリックしたというのは、<code>outer</code> をクリックしたということでもある
*  イベントは実際に発生したノードから親に向かって浮上 (バブル) していく
*  バブルしないイベントもある (<code>focus</code>、<code>load</code>、etc.)

http://www.w3.org/TR/2011/WD-DOM-Level-3-Events-20110531/
<img src="http://www.w3.org/TR/2011/WD-DOM-Level-3-Events-20110531/images/eventflow.png" />

##  <code>load</code> イベントについて

*  DOM の構築
*  画像のロード

などが終わった直後に発生するイベント

基本的に <code>load</code> イベントが発生しないと、要素に触れません。


``` text
window.addEventListener('load', function (e) {
   alert('load');
}, false);
```

みたいに書くのが普通

##  イベントオブジェクトの構成要素


``` javascript
document.body.addEventListener('click', function (e) {
    alert(e.target);
}, false);
```

コールバックに渡されるオブジェクト

*  <code>target</code> : イベントのターゲット (クリックされた要素)
*  <code>clientX</code>, <code>clientY</code> : クリックされた場所の座標
*  <code>stopPropagation()</code> : イベントの伝播 (含むバブリング) をとめる
*  <code>preventDefault()</code> : イベントのデフォルトアクションをキャンセルする
  *  デフォルトアクション : リンクのクリックイベントなら、「リンク先のページへ移動」

https://developer.mozilla.org/en/DOM/event をみるといいです

##  オブジェクトのメソッドをイベントハンドラとして使う

``` javascript
function Notifier(element, message) {
    this.message = message;

    var self = this;
    element.addEventListener('click', function (event) {
        self.notify();
    }, false);
}

Notifier.prototype.notify = function () {
    alert(this.message);
};

new Notifier(document.body, 'Clicked!');
```
*  <code>addEventListener('click', this.notify, false)</code> では<code>notify</code> 中の <code>this</code> が何を指すかわからない
*  最近のブラウザなら <code>this.notify.bind(this)</code> とも書ける

##  質問

*  非同期プログラミンング
*  並列性なし
*  イベントドリブン
*  イベントオブジェクト

#  XMLHttpRequest

##  <code>XMLHttpRequest</code>

*  所謂 AJAX というやつのキモ
*  JS から HTTP リクエストを出せる

##  生 <code>XMLHttpRequest</code> の使いかた


``` javascript
var xhr = new XMLHttpRequest();
xhr.open('GET', '/api/foo', true);
req.onreadystatechange = function (e) {
  if (xhr.readyState == 4) {
    if (xhr.status == 200) {
      alert(xhr.responseText);
    } else {
      alert('error');
    }
  }
};
req.send(null);
```

通常どんなJSフレームワークもラッパーが実装されてます

とはいえ一回は生で使ってみましょう

##  XMLHttpRequest での POST

POST するリクエスト body を自力で 作ります


``` javascript
var xhr = new XMLHttpRequest();
xhr.open('POST', '/api/foo', true);
req.onreadystatechange = function (e) { };
var params = { foo : 'bar', baz : 'Hello World' };
var data = ''
for (var name in params) if (params.hasOwnProperty(name)) {
  data += encodeURIComponent(name) + "=" + encodeURIComponent(params[name]) + "&";
}
// data //=> 'foo=bar&baz=Hello%20World&'

req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
req.send(data);
```

みたいなのが普通。<a href="http://www.studyinghttp.net/cgi-bin/rfc.cgi?1867">multipart</a>も送れるけどまず使わない

##  JSON をリモートから読みこむ

*  JSON : オブジェクトのシリアライズ形式の一種。JS のオブジェクトリテラル表記と一部互換性がある
最近のブラウザなら <code>JSON</code> オブジェクトがありますが、古いブラウザにも対応するときは自分で <code>eval</code> します
https://developer.mozilla.org/ja/Using_native_JSON


``` javascript
var xhr = new XMLHttpRequest();
xhr.open('GET', '/api/status.json', true);
req.onreadystatechange = function (e) {
  if (xhr.readyState == 4) {
    if (xhr.status == 200) {
      var json = eval('(' + xhr.responseText + ')');
    } else {
      alert('error');
    }
  }
};
req.send(null);
```

##  質問

*  <code>XMLHttpRequest</code>

###  ハマりポイント

*  http 経由じゃないと XHR うまくうごかない

#  jQuery

##  jQuery

*  世界的によく使われているライブラリ
*  はてなでも採用事例が増えてきている
*  書き方がちょっと独特


``` javascript
// ページが読み込まれたときに
$(function ($) {
    // 文書中のすべての p 要素の背景色と文字色を変える
    $('p').css({ backgroundColor: '#ff0', color: '#000' });
});
```

##  jQuery を使う


``` html
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js"></script>

<!-- 開発中はこちらのほうがデバッグが楽かも? -->
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.js"></script>
```

*  http://docs.jquery.com/
*  http://api.jquery.com/

##  jQuery の使い方


``` javascript
jQuery === $ //=> どちらも同じ jQuery 関数を指す

$(function ($) { ... });
  //=> 文書読み込み完了時に関数を実行

$('css selector');
  //=> CSS セレクタで要素を選択し、
  //   それらの要素が含まれる jQuery オブジェクトを作成

$('<p>HTML fragment</p>');
  //=> HTML 要素を内容込みで作成し、
  //   その要素が含まれる jQuery オブジェクトを作成
```

##  jQuery の使い方、イベント編


``` javascript
$('.foo').on('click', function (event) { ... });
  //=> foo クラスを持つ要素の click イベントを指定
  //=> イベントを登録する要素は実行時点で存在したもののみ

$('.foo').click(function (event) { ... });
  //=> 上と同じ

$(document).on('click', '.foo', function (event) { ... });
  //=> foo クラスを持つ要素の click イベントを指定
  //=> 実行時点で存在したかに関わらず、文書中のすべての
  //   foo クラスを持つ要素の click イベントを監視
```

##  jQuery の使い方、リクエスト編


``` javascript
$.get(url, { foo: 42 }).done(function (res) {
    alert(res);
});

$.post(url, { foo: 42 }).done(function (res) {
    alert(res);
});

$.ajax({ url: url, ... });
```

##  質問

*  jQuery

#  MVC アーキテクチャ

##  MVC アーキテクチャ

*  <span lang="en">Model-View-Controller</span>
*  これまでの課題でやった Web アプリケーションの MVC とはちょっと違う
  *  「Web アプリケーションの MVC」を「MVC2」と呼ぶこともある
###  Web アプリケーションの MVC
<img src="http://cdn-ak.f.st-hatena.com/images/fotolife/n/ninjinkun/20100802/20100802222932.png" />
*  Model は一方的に操作され、またはデータを読み取られるのみ
###  クライアントサイドプログラミングの MVC
<img src="http://cdn-ak.f.st-hatena.com/images/fotolife/n/ninjinkun/20100802/20100802223034.png" />
*  Model はしばしば observer パターンを実装し、自身の状態の変更を View に<strong>通知する</strong>

##  クライアントサイドプログラミング
*  Web API (HTTP リクエストを送り、テキストや JSON で結果を受け取るような API) をそのまま Model として使うこともある
*  規模が小さい場合、View と Controller は一緒くたに実装することもある

###  例

*  <code>/api/time.json</code> にアクセスすると <code>{ "time": "2012-04-01 12:00:00" }</code> というJSON 形式で現在時刻を返す API があるとする
*  ボタンを押すと時刻表示を更新するようなウィジェットを作る

``` html
<script>

var TimeWidget = function (button, output) {
    this.button = $(button);
    this.output = $(output);
    this.button.click(this.onClick.bind(this));
};

TimeWidget.prototype = {
    onClick: function (event) {
        $.get('/api/time.json').done(this.onGetTime.bind(this));
    },
    onGetTime: function (res) {
        this.output.text(res.time);
    }
};

$(function () {
    new TimeWidget($('#time-update-button'), $('#time-output'));
});

</script>

<p>
  <input id="time-update-button" type="button" value="表示を更新">
  <span id="time-output"></span>
</p>
```

##  Observer パターン
*  jQuery を使えば大抵のオブジェクト上で observer パターンを実装できる

``` html
<script>

// Model に相当
function Toggler() {
    this.enabled = true;
}

Toggler.prototype.toggle = function () {
    this.enabled = !this.enabled;
    // jQuery の機能を使って自身の状態が変化したことを通知する
    $(this).triggerHandler('update');
};

// View-Controller に相当
function ToggleDisplay(toggler, output, messages) {
    this.toggler = toggler;
    this.output = output;
    this.messages = messages;
    // jQuery の機能を使って Model の状態を監視する
    $(this.toggler).on('update', this.onUpdate.bind(this));
}

ToggleDisplay.prototype.onUpdate = function () {
    this.output.text(this.messages[this.toggler.enabled ? 0 : 1]);
};

$(function () {
    var toggler = new Toggler();
    new ToggleDisplay(toggler, $('#display-ja'), ['有効', '無効']);
    new ToggleDisplay(toggler, $('#display-en'), ['Enabled', 'Disabled']);
    setInterval(function () {
        toggler.toggle();
    }, 1000);
});

</script>

<p id="display-ja" lang="ja"></p>
<p id="display-en" lang="en"></p>
```
*   1 秒ごとに「有効」「無効」(または <span lang="en">"Enabled", "Disabled"</span>) の表示が切り替わる

##  質問

*  MVC アーキテクチャ

#  課題

##  課題1 (3.5点)

*  ページ継ぎ足し機構を作れ (ダイアリー、グループにあるようなもの)
  *  DOM を理解する
  *  XHR を使える
  *  イベントを理解する (<code>click</code>, <code>load</code>)
jQuery、Ten といったフレームワークを使ってもよい

###  ヒント

手順

+ 継ぎ足しを実行するトリガーとなる要素にイベントを設定
++ 次のページの識別子をどうにかして取得
+ サーバサイドに API を作る (<code>/api/page?id=...</code>) みたいな
++ ページの識別子を受け取ってそのページの内容を返す
+ <code>XMLHttpRequest</code> で API を叩く
+ 表示を更新する
++ <code>createElement</code>, <code>removeChild</code>, <code>appendChild</code>...

スクリプトファイル置き場

*  <code>static/js/diary.js</code> などに JS ファイルを設置すると、
*  HTML からは <code>&lt;script type="text/javsacript" src="/js/diary.js"&gt;&lt;/script&gt;</code> でその JS ファイルを参照できます

###  配点

*  動くこと (1.5)
*  設計 (1)
*  UIへの配慮 (1)

##  課題2 (3.5点)

タイマーを管理する <code>Timer</code> クラスをつくれ。

*  コールバックを概念を理解する
jQuery、Ten といったフレームワークを使っては<strong>いけない</strong>

###  仕様


``` javascript
var timer = new Timer(time);
    //=> time ミリ秒のタイマーを作る
timer.addListener(callback1);
    //=> タイマーが完了したときに呼ばれる関数を追加する
    //=>  callback : Function => タイマーが完了したときに呼ばれる関数
timer.addListener(callback2);
    //=> タイマーが完了したときに呼ばれる関数は、複数指定できる
timer.start();
    //=> タイマーをスタートさせる。
    //=> start() してからコンストラクタに指定したミリ秒後に addListener に指定したコールバックが呼ばれる
timer.stop();
    //=> タイマーをストップさせる。
```

###  例


``` javascript
var timer = new Timer(1000);
timer.addListener(function (e) {
  alert(e.realElapsed); //=> start() 時から実際に経過した時間
  timer.start(); //=> 再度スタートできる
});
timer.start();

document.body.addEventListener('click', function () {
  timer.stop(); //=> クリックで止まる。
}, false);
```

以上のようなインターフェイスの <code>Timer</code> クラスを作れ。(ライブラリを使わずに)

###  ヒント

+ <code>Timer</code> の <code>addListener</code> は自分で実装しろということです (DOM のメソッドではない)
+ <a href="https://developer.mozilla.org/ja/DOM/window.setTimeout"><code>setTimeout()</code></a> を使うことになると思います


###  配点

*  動くこと (1.5)
*  設計 (1)
*  <code>removeListener</code> を実装 (1)

##  課題3 (3点)

*  その場編集機能を作れ
  *  要素の作成、追加、削除
  *  こまめなフィードバックでストレスを感じさせないように
  *  その場編集用 API の設計
jQuery、Ten といったフレームワークを使ってもよい

###  配点

*  動くこと (1)
*  設計 (1)
*  UIへの配慮 (1)
