# Perl によるプログラミングの基礎

## この講義の目的
* 明日以降、Perlの言語自体にはまらない
  * 今日、いろいろやって、なるべくはまってください
  * 疑問があったらどんどん質問してください

## 目次
* Perlプログラミング勘所
* Perlによるオブジェクト指向プログラミング
* テストを書こう
* ヒント
* 課題について

# Perlプログラミング勘所

## 質問
* Perlでプログラミングをしたことがありますか?

## はじめに
* 事前課題
  * https://github.com/hatena/Hatena-Intern-Exercise2016

* 前提
  * はじめてのPerl、続はじめてのPerlに目を通している
  * 一度はPerlでオブジェクト指向プログラミングしたことがある
    * 事前課題でやっているはず

## Perlの良いところ
* [CPAN](http://www.cpan.org/)
  * やりたいことがすでにモジュール化されていることが多い
  * それCPANでできるよ
* 表現力が高い
  * TMTOWTDI (やりかたはいくつもあるよ！)
* 実際に使われてる
  * はてな/DeNA/LINE/mixi
* 良い開発文化がある
  * http://b.hatena.ne.jp/t/perl

## 副読サイト
* http://perldoc.jp/ : perldocの日本語訳
* https://metacpan.org/ : CPANの検索

## Perlプログラミング勘所
* Perlでおさえておきたい/よくはまるポイントを説明
  * use strict; use warnings;
  * use utf8;
  * データ型
  * コンテキスト
  * リファレンス
  * パッケージ
  * サブルーチン

## use strict; use warnings;
* ファイルの先頭には必ず書きましょう

``` perl
use strict;
use warnings;
```

* デフォルトの振る舞いは互換性のために制限が弱い

## use strict; use warnings;を書かないと困ること
``` perl
my $message = "hello";
print $messsage; # typo!
# => エラーにならない!
$messagge = "bye"; # typo!
# => $messagge がグローバル変数になる！
```
* 細かな振る舞いはperldoc参照

``` zsh
$ perldoc strict
$ perldoc perllexwarn
```

## use utf8;

Perl での文字コードの扱いについて

* Perl では文字列は以下のどちらかで表されます
  * Perl の内部表現に変換された文字列
  * バイト列

## なんのこっちゃ

次の内容を UTF-8 でファイル(hoge.pl)に保存します

``` perl
print 'ほげ';
```

実行します

``` bash
$ perl hoge.pl
ほげ
```

ええやん

## じゃ次

length は文字数をカウントする関数

``` perl
print length 'ほげ';
```

実行します

``` bash
$ perl hoge.pl
6
```

あかんやん

## なぜか

* 'ほげ' はマルチバイト文字
* 何もしないと Perl は 'ほげ' をバイト列とみなす
* UTF-8 の 'ほげ' は 6 バイトなので length 'ほげ' は 6 になる
* 文字数数えるのに困る

## そこで use utf8;

``` perl
use utf8;
print length 'ほげ';
```

``` bash
$ perl hoge.pl
2
```

ええやん!

## なにをしたの

* utf8 プラグマをつけると、 Perl はコード内のマルチバイト文字を UTF-8 の文字列として解釈し、Perl 内部表現の文字列に変換する
* UTF-8 で記述された 'ほげ' を UTF-8 として解釈すると当然 2 文字なので、length 'ほげ' は 2 になる

めでたしめでたし!!

## ...けど

``` perl
use utf8;
print 'ほげ';
```

``` bash
$ perl hoge2.pl
Wide character in print at hoge2.pl line 2.
ほげ
```

なんか出た…

'ほげ' は Perl 内部表現に変換されているので、そのまま Perl の世界の外に出そうとすると怒られる
再びバイト列に変換してあげる必要がある

``` perl
use utf8;
use Encode;
print encode_utf8 'ほげ';
```

これでOK

## use utf8;

* まとめると
  * ファイルは UTF-8 で保存する
  * use utf8; プラグマを忘れないように
* 難しかったらこれだけ守って下さい
* strict と warnings も忘れずに

## データ型
* スカラ
* 配列
* ハッシュ
* (ファイルハンドル)
* (型グロブ)

## スカラ
* 1つの値
* 文字列/数値/リファレンス
* $calar と覚えましょう

``` perl
my $scalar1 = 'test';
my $scalar2 = 1000;
my $scalar3 = \@array; # リファレンス(後述)
```

## 配列
* @rray と覚えましょう

``` perl
my @array = ('a', 'b', 'c');
```

* Q: @array の二番目の要素を取得するには?

## 配列の操作
``` perl
print $array[1]; # 'b'
```

* スカラを取得するので$でアクセス
* $array と @array とは別の変数


## 配列の操作
``` perl
$array[0]; # get
$array[1] = 'hoge'; # set
my $length = scalar @array; # 長さ
my $last_ids = $#array; # 最後の添字
my @slice = @array[1..4]; # スライス
for my $e (@array) { # 全要素ループ
    print $e;
}
```
*  チェックしておこう！
  * 関数: push/pop/shift/unshift/map/grep/join/sort/splice
    * `perldoc -f push`
  * モジュール: List::Util/List::MoreUtils/List::UtilsBy
    * インストールしているなら `perldoc List::Util`
    * していなかったら [metacpan で検索](https://metacpan.org/search?q=List%3A%3AUtil)

## ハッシュ
* %ash とおぼえましょう

``` perl
my %hash = (
    perl => 'larry',
    ruby => 'matz',
);
```

* Q: hash の key `perl` に対応する値を取得するには?

## ハッシュの操作
``` perl
print $hash{perl}; # larry
print $hash{ruby}; # matz
```

* スカラを取得するので$
* $hash と %hash は別の変数
* {} の中は裸の文字列( = `'`, `"`がない)が許される

## ハッシュの操作
``` perl
$hash{perl}; # get
$hash{perl} = 'larry'; # set
for my $key (keys %hash) { # 全要素のキー
    my $value = $hash{$key}; # キーで各要素を get
}
```
* チェックしておこう！
  * 関数: keys/values/delete/exists
    * `perldoc -f keys`

## データ型まとめ
* スカラ $ / 配列 @ / ハッシュ %
* $val と @val と %val は別の変数

``` zsh
$ perldoc perldata
```

## コンテキスト
* Perlといえばコンテキスト
* 代表的ハマリポイント
* 式が評価される場所( = コンテキスト)によって結果が変わる

``` perl
my @x = (0, 1, 2);
my ($ans1) = @x;
my $ans2 = @x;
```
* それぞれ何が入っているでしょうか?

## コンテキスト
``` perl
my @x = (0, 1, 2);
my ($ans1) = @x; # => 0
my $ans2 = @x; # => 3

```
* 配列への代入の右辺はリストコンテキスト
  * 0 が代入される。1,2 は捨てられる
* スカラへの代入の右辺はスカラコンテキスト
  * 配列はスカラコンテキストで評価すると長さが返る

## コンテキストクイズ
* <ここ> のコンテキストはスカラ? リスト?

``` perl
sort <ここ>;
length <ここ>;
if (<ここ>) { }
for my $i (<ここ>) { }
$obj->method(<ここ>);
my $x = <ここ>;
my ($x) = <ここ>;
my @y = <ここ>;
my %hash = (
    key0 => 'hoge',
    key1 => <ここ>,
);
scalar(<ここ>);
<ここ>;
```

## コンテキストまとめ
* 式/値が評価される場所によって結果がかわる
* コンテキストの決まり方は基本的に覚えるしかない
  * 組み込み関数に注意(length など)
  * 組み込み関数以外も prototype という機能で実現可能なので注意
  * 関数の側からは wantarray で今呼ばれているコンテキストを知ることができます

``` zsh
$ perldoc perldata
$ perldoc perlsub # Prototypes の章
$ perldoc -f wantarray
```


## リファレンス
* スカラ/配列/ハッシュ などへの参照
  * C++とかの参照/Rubyなどではすべて参照
  * データ構造を作るときに重要

## データ構造はまりポイント1
* 行列をつくろう

``` perl
my @matrix = (
    (0, 1, 2, 3),
    (4, 5, 6, 7),
);
```

* どうなるでしょうか…


## こうなります
``` perl
my @matrix =
    (0, 1, 2, 3, 4, 5, 6, 7);
```
* ひー

## データ構造はまりポイント2
``` perl
my %entry = (
    body => 'hello!',
    comments => ('good!', 'bad!', 'soso'),
)
```
* どうなるでしょうか…

## こうなります
``` perl
my %entry = (
    'body' => 'hello!',
    'comments' => 'good',
    'bad!' => 'soso',
);
```
* ひー

## なぜか?
* () の中はリストコンテキスト
* リストコンテキスト内ではリストは展開される

``` perl
my @matrix = (
    (0, 1, 2, 3),
    (4, 5, 6, 7),
);
```

## リファレンスの取得/作成 (配列)
``` perl
my @x = (1, 2, 3);
my $ref_x1 = \@x;

# 略記法
$ref_x2 = [1, 2, 3];

# 組み合わせ
$ref_x3 = [@x];
```

## デリファレンス (配列)
``` perl
my $ref_x = [1, 2, 3];

my @x = map { $_ * 2 } @$ref_x;

print $ref_x->[0]; # 1

my @new_x = @$ref_x;
print $new_x[0]; # 1
```

## リファレンスの取得/作成 (ハッシュ)
``` perl
my %y = (
    perl => 'larry',
    ruby => 'matz',
);
my $ref_y1 = \%y;

# 略記法
$ref_y2 = {
    perl => 'larry',
    ruby => 'matz',
};
```

## デリファレンス (ハッシュ)
``` perl
my $ref_y = {
    perl => 'larry',
    ruby => 'matz',
};

my @keys = keys %$ref_y;

print $ref_y->{perl}; # larry

my %new_f = %$ref_y;
print $new_f{perl}; # larry
```

## データ構造の作成
* リファレンスはスカラ値 = リストコンテキストで展開されない

``` perl
my $matrix = [
    [0, 1, 2, 3],
    [4, 5, 6, 6],
];
```

``` perl
my $entry = {
    body => 'hello!',
    comments => ['good!', 'bad!', 'soso'],
};
```


## 複雑なデリファレンス
* 例: リファレンスを返すメソッドの返り値をデリファレンス

``` perl
my $result = [
    map {
        $_->{bar};
    }
    @{ $foo->return_array_ref }
    # ↑ レースを使う
];
```

## おすすめ
* 基本的にリファレンス以外使わない
  * ハマリにくい

``` perl
my @foo = (1, 2, 3);
my %foo = (a => 1, b => 2, c => 3);
$foo[1], $foo{a}
# ↑ 同じ変数を参照しているように見える……
# が実際は違う変数
```
``` perl
my $foo = [1, 2, 3];
my $foo = {a => 1, b => 2, c => 3};
# ↑ 同じ変数なので warning がでる
```

## おすすめ
必要なときだけデリファレンスする

``` perl
my $list = [1, 2, 3];
push @$list, 4;
```

## リファレンスでないリスト/ハッシュを使うと便利
* サブルーチンの引数の処理(後述)
* 多値を返すとき

``` perl
sub hello {
    my ($arg1, $arg2, %other_args) = @_;
    return ($arg1, $arg2);
}
my ($res1, $res2)
    = hello('hey', 'hoy', opt1 => 1, opt2 =>2);
```

## リファレンスまとめ
* スカラ/配列/ハッシュへの参照
* 複雑なデータ構造を扱うときに必須
* 記法がちょっと複雑

``` zsh
$ perldoc perlreftut
$ perldoc perlref
```

## パッケージ
* 名前空間
* モジュールロードのしくみ
* クラス(後述)

``` perl
package Hoge;
our $PACKAGE_VAL = 10;
# $HOGE::PACKAGE_VAL == 10

sub fuga {
}
# Hoge::fuga();

1;
```

## モジュールロードのしくみ
``` perl
use My::File;
# => My/File.pm がロードされる
```
* @INC(グローバル変数)に設定されたパスを検索

``` perl
use lib 'path/to/your/lib';
$ perl -Ipath/to/your/lib;
```

* path/to/your/lib/My/File.pm をさがしてあれば読み込む

## サブルーチン
``` perl
hello() # 定義前に括弧なしで呼ぶにはは & がいる
sub hello {
    my ($name) = @_;
    return "Hello, $name";
}
hello();
hello; # 定義後であれば括弧は省略可能
```

## 引数処理イディオム1
``` perl
sub func1 {
    my ($arg1, $arg2, %args) = @_;
    my $opt1 = $args{opt1};
    my $opt2 = $args{opt2};
}
func1('hoge', 'fuga', opt1 => 1, opt2 => 2);
```

## 引数処理イディオム2
``` perl
sub func2 {
    my $arg1 = shift; # 暗黙的に@_を処理(破壊的)
    my $arg2 = shift;
    my $args = shift;
    my $opt1 = $args->{opt1};
    my $opt2 = $args->{opt2};
}
```

## 引数処理イディオム3
``` perl
sub func3 { shift->{arg1} }
```

``` perl
sub func4 { $_[0]->{arg1} } # @_ の第0要素
```

## サブルーチンの名前空間
* パッケージに定義される

``` perl
package Greetings;
sub hello { }
1;

# hello は Greeting::hello(); として定義される
```

* ネストしてもパッケージに定義されるので注意

``` perl
package Greetings;
sub hello {
    sub make_msg { }
    sub print {}
    print (make_msg() );
}
1;

# Greeting::hello();
# Greeting::make_msg();
# Greeting::print();
```

* package が無いときは main パッケージ

``` perl
sub hello { }

# main::hello()
```

## 質問 => 休憩


# Perlによるオブジェクト指向プログラミング

## 質問
* オブジェクト指向プログラミングしたことありますか?
  * Perl以外でも

## ですよねー
* 念のためポイントだけおさえておきます

## プログラミングにおける抽象化の歴史
* 抽象化とは

> 詳細を捨象し、一度に注目すべき概念を減らすことおよびその仕組み

[抽象化 (計算機科学)](http://ja.wikipedia.org/wiki/%E6%8A%BD%E8%B1%A1%E5%8C%96_(%E8%A8%88%E7%AE%97%E6%A9%9F%E7%A7%91%E5%AD%A6)) より

* 一度に考えないといけないことを減らす
  *  = スコープをせばめる
  * 保守性/再利用性を高める

## 非構造化プログラミング時代
* gotoプログラミング
  * 制御のながれがすべて自由

* Perl で gotoプログラミングした例(fizzbuzz)

``` perl
my $i = 1;
START:
    goto "END" if $i > 35;

    goto "PRINT_FIZZBUZZ" if $i % 15 == 0;
    goto "PRINT_FIZZ"     if $i %  3 == 0;
    goto "PRINT_BUZZ"     if $i %  5 == 0;
    goto "PRINT_NUM";

PRINT_NUM:_
    print $i;
    goto "PRINT_NL";

PRINT_FIZZ:_
    print "fizz";
    goto "PRINT_NL";

PRINT_BUZZ:_
    print "buzz";
    goto "PRINT_NL";

PRINT_FIZZBUZZ:_
    print "fizzbuzz";
    goto "PRINT_NL";

PRINT_NL:_
    print "\n";

    $i++;
    goto "START";

END:
```

## 非構造化プログラミングの問題
* 制御の流れが分かりにくい
  * プログラム全体を一度に理解していないといけない
  * 大規模なソフトウェアになると保守できなくなる
* コードの再利用は実質的にはできない

``
EW Dijkstra(1968). Go to statement considered harmful
``

## 構造化プログラミング
* 手続きを逐次、選択、繰り返しで表現
* サブルーチンにより手続きを抽象化

``` perl
sub fizzbuzz {
    my $i = 1;

    while ($i < 35) {
        if ($i % 15 == 0) {
            print "fizzbuzz";
        }
        elsif ($i % 3 == 0) {
            print "fizz";
        }
        elsif ($i % 5 == 0) {
            print "buzz";
        }
        else {
            print $i;
        }
        print "\n";
        $i++;
    }
}
fizzbuzz();
```

## 構造化プログラミングのみを用いる問題
* 手続きとデータがばらばら

``` perl
open my $fh, '<', $filename;
while (my $line = readline($fh)) {
    print $line;
}
close $fh;
```
* $fhに対してどのような操作ができるのか?
* open/close/readline はどんなデータを操作できるのか?
  * データと手続きそれぞれのスコープが広い

## オブジェクト指向プログラミング
* オブジェクトによる抽象化
* オブジェクトとは
  * プログラムの対象となるモノ
  * データ + 手続き

* プログラムはオブジェクト同士の相互作用
* "どう"ではなく"なにがどうする"に着目する

## オブジェクト指向プログラミングの良いところ
* 処理の対象(データ)と処理の内容(手続き) が結びついている
  * オブジェクトごとにコードを理解できる
  * 再利用しやすい
* オブジェクトというメタファが人間にとってわかりやすい (こともある)
  * => 設計しやすい

## 例

``` perl
use IO::File;
my $file = IO::File->new($filename, 'r');
while (my $line = $file->getline) {
    print $line;
}
$flie->close;
```
* $fileに対してできる操作はすべてメソッドとして定義されている

## オブジェクト指向プログラミングの実現
* オブジェクト間の相互作用/メッセージパッシング
* オブジェクト間の相互作用を表現しやすいようにプログラミング言語が支援
  * クラスとインスタンス
  * カプセル化
  * 継承
  * ポリモーフィズム
  * ダイナミックバインディング

## 本題

## Perlにおけるクラスとインスタンス

``` text
      クラス: [ データ構造定義 + 手続定義 ]
                       ↓　生成
インスタンス: [ { データ } + 手続への参照 ]
```

|OOP概念|Perlでの実装|
|-----|---------|
|クラス|パッケージ|
|メソッド|パッケージに定義された手続き|
|オブジェクト|特定のパッケージにbless()されたリファレンス|

##  クラス定義 (クラス名)
* 課題ででた Parser クラス(簡易版)

``` perl
# パッケージに手続きを定義
package Parser; # クラス名
use strict;
use warnings;

# 続く

1;
```

## クラス定義 (コンストラクタ/フィールド)

``` perl
# コンストラクタ
# Parser->new; のように呼び出す
sub new {
    my ($class, %args) = @_; # クラス名が入る
    return bless \%args, $class;
}
```

## クラス定義 (メソッド)

``` perl
# $parser->parse(filename => 'hoge.log'); のように呼び出す
sub parse {
    my ($self, %args) = @_;
    my $filename = $args{filename};
    ...
}
```

## クラスの使用

``` perl
use Parser;

my $parser = Parser->new;
$parser->parse(filename => 'hoge.log');
```

## コンストラクタ
* コンストラクタは自分で定義する
* (blessされた)オブジェクトも自分で作る
* new()
  * リファレンス を パッケージ(クラス) で bless して返す
* blessはデータと手続きを結びつける操作

``` perl
  my $self = bless { filename => 'hoge.log' }, 'Parser';
```

## クラスメソッドとインスタンスメソッド
* 文法的違いはない
* 定義時: 第一引数を$classとみなすか$selfとみなすか
* 呼出時: クラスから呼び出すかインスタンスから呼び出すか

``` perl
# この二つが等価
Class->method($arg1, $arg2);
Class::method('Class', $arg1, $arg2);

# この二つが等価
$object->method($arg1, $arg2);
Class::method($object, $arg1, $arg2);
```

## フィールド
* 1インスタンスに付き1データ(のリファレンス)
* 複数のデータをもちたい場合はハッシュをbless する

``` perl
my $self = bless {
    filed1 => $obj1,
    field2 => [],
    field3 => {},
}, $class;
```

## カプセル化
* 可視性の指定(public/privateなど) はない
  * すべてが public
* 命名規則などでゆるく隠蔽する

``` perl
sub public_method {
    my $self = shift;
}

sub _private_method {
    my $self = shift;
}
```
* 完全に隠蔽する方法もある(クロージャを使う)

## 継承
* use parent を使う

``` perl
package Me;
use parent 'Father';
1;
```
* 親クラスのメソッド
  * SUPER

``` perl
sub new {
    my ($class) = @_;
    my $self = $class->SUPER::new();
    return $self;
}
```

## 多重継承
* Mixinをやりたいときなどにつかう
* 乱用しない

``` perl
package Me;
use parent qw(Father Mother); # 左 => 右の順
1;
```
* メソッドの検索アルゴリズム
  * Class::C3
  * NEXT

## オブジェクト指向のまとめ
* 手作り感あふれるオブジェクト指向
  * package に手続きを定義
  * blessでデータと結びつける
  * コンストラクタは自分でつくる、オブジェクトも自分で作る
  * オブジェクト指向風によびだせるような糖衣

* オブジェクト指向に必要な機能はそろっている

## UNIVERSAL
* JavaでいうObjectのようなもの
* UNIVERSALに定義するとどのオブジェクトからも呼べる
* isa()

``` perl
my $dog = Dog->new;
$dog->isa('Dog');    # true
$dog->isa('Animal'); # true
$dog->isa('Man');    # false
```
* can()

``` perl
my $bark = $dog->can('bark');
$man->$bark();
```

## AUTOLOAD
* 呼び出されたメソッドがMy::Classクラスに見つからない場合、
  * My::Class::AUTOLOADメソッドを探す
  * 親クラスのAUTOLOADメソッドを探す
  * UNIVERSAL::AUTOLOADを探す
  * なかったらエラー

* AUTOLOADメソッドで未定義のメソッド呼び出しを補足
* Ruby の method_missing

## AUTOLOAD
* フィールドを動的に定義できたりする
* 想像できない振る舞いを作り出し得るのでなるべく使わない
  * こういう仕組みがあることは理解しておく

``` perl
package Foo;

sub new { bless {}, shift }

our $AUTOLOAD;
sub AUTOLOAD {
    my $method = $AUTOLOAD; # 呼び出そうとしていたメソッド名
    return if $method =~ /DESTROY$/;
    $method =~ s/.*:://;
    {
        # 定義してやる
        no strict 'refs';
        *{$AUTOLOAD} = sub {
            my $self = shift;
            sprintf "%s method was called!", $method;
        };
    }
    # 呼び出す
    goto &$AUTOLOAD;
}

1;
```

## 演算子のオーバーロード
* 想像できない振る舞いを作り出し得るのでなるべく使わない
  * こういう仕組みがあることは理解しておく
* URI

``` perl
my $uri = URI->new('http://exapmle.com/');
$uri->path('hoge');
print "URI is $uri"; # 'URI is http://exapmle.com/hoge'
```

* DateTime

``` perl
$new_dt = $dt + $duration_obj;
$new_dt = $dt - $duration_obj;
$duration_obj = $dt - $new_dt;
for my $dt (sort @dts) { # sort内で使われる<=>がoverloadされている
    ...
}
```

## クラスビルダー
* Perlのオブジェクト指向は手作り感満載
  * newは自分でつくる
  * フィールドのアクセサも自分で定義

* たいへんなので自動化されている

## Class::Accessor::Lite

* 継承ツリーを汚さない
* おすすめ

``` perl
package Foo;

use Class::Accessor::Lite (
    new => 1,
    rw  => [ qw(foo bar baz) ],
);
```

### before

``` perl
package Foo;

sub new {
    bless {
        foo => undef,
        bar => undef,
        baz => undef,
    }, shift
}

sub foo {
    my $self = shift;
    $self->{foo} = $_[0] if defined $_[0];
    $self->{foo};
}

sub bar {
    my $self = shift;
    $self->{bar} = $_[0] if defined $_[0];
    $self->{bar};
}

sub baz{
    my $self = shift;
    $self->{baz} = $_[0] if defined $_[0];
    $self->{baz};
}

1;
```

## 他のクラスビルダー

### Class::Accessor::Fast
* コンストラクタ/フィールドのアクセサを自動的に定義
* 利用するのに Class::Accessor::Fast を継承する必要があるので使いにくい

### Moose
* モダンなオブジェクト指向を実現するモジュール
* 柔軟かつ安全なアクセサの生成
* 型の採用
* Roleによるインタフェイス指向設計

* プロジェクトの複雑性をあげるのであまりつかわない

### Mouse
* Moose の軽量版
  * Moose はモジュール読み込み時のコストが高い
  * 機能は一部制限

## オブジェクト指向でプログラムを書くコツ

* 登場人物を考える = オブジェクト
* 登場人物がそれぞれどのような責務を持つべきかを考える
* 責務にあわせてスコープを限定するように書く
  * 「カプセル化で継承でポリモーフィズムが……」とか考えても意味ない
  * よりよい、わかりやすく問題をモデリングするための手段

## 責務とは?

* オブジェクトの利用者、メソッドの呼び出し元との約束
  * 責任のないことはやらなくていい
  * 責任のないことはやっちゃだめ
* 責務を綺麗に切り分けることで、綺麗に設計できる


## Perl のオブジェクト指向のまとめ
* 手作り感あふれるオブジェクト指向
  * package に手続きを定義
  * bless でデータ(リファレンス)と結びつける
  * コンストラクタは自分でつくる
  * オブジェクト志向風によびだせるような糖衣

# テストを書こう

## テスト重要
* プログラムを変更する二つの方法 [レガシーコード改善ガイドより]
  * 編集して祈る
  * テストを書いて保護してから変更する

## なぜテストを書くのか

* テストがないと、プログラムが正しく動いているかどうかを証明できない
* 大規模プロジェクトでは致命的
  * 昔書いたコードは今もうごいているのか?
  * 新しいコードと古いコードの整合性はとれているのか?
  * 正しい仕様/意図が何だったのかわからなくなっていないか?
* Perlのような型のない動的言語では特に重要

* 祈らずテストを書こう!

## 何をテストするのか

* 正常系
* 異常系
* 境界

* 100% の カバーは難しい
  * 命令網羅(C0)/分岐網羅(C1)/条件網羅(C2)
  * C2 とかはたいへん
* 必要/危険だと思われるところから書き、少しづつ充実する

## PerlでTest

* Test::More
* Test::Fatal
* Test::Class

## Test::More

``` perl
use Test::More;

subtest 'topic' => sub {
	use_ok    'Foo::Bar';
	isa_ok    Foo::Bar->new, 'Foo::Bar';
	ok        $something_to_be_bool;
	is        $something_to_be_count, 5;
	is_deeply $something_to_be_complicated, {
	    foo => 'foo',
	    bar => [qw(bar baz)],
	};
};

done_testing;
```

## Test::Fatal

``` perl
use Test::Fatal;

ok( exception{ $foo->method }, '例外が発生する');
like( exception { $foo->method },  qr/division by zero/, '0除算エラーが発生する');
isa_ok( exception { $foo->method }, 'Some::Exception::Class', '例外クラスがthrowされる);
```

## Test::Class
* テストコードをメソッドにわける
* xUnit系

``` perl
package Example::Test;
use parent qw(Test::Class);
use Test::More;

sub setup : Test(setup) {
    # 各々のテストが実行される前に実行される
};

sub test_pop : Tests {
    ok ...
    is ...
    is_deeply ...
};

sub teardown : Test(teardown) {
    # 各々のテストが実行された後に実行される
};
```

## テストの実行
* テストコードは t ディレクトリに.t拡張子をつけて保存
  * t/hoge.t
* proveコマンド(Test::Moreに付属)で実行する

``` zsh
$ prove -lvr t
t/hoge.t ..
ok 1 - L8: is Hoge::hey(10), 100;
1..1
ok
All tests successful.
Files=1, Tests=1,  0 wallclock secs ( 0.02 usr  0.01 sys +  0.03 cusr  0.01 csys =  0.07 CPU)
Result: PASS
```

## テストを書くコツ
* まず、こういう振る舞いで有るべきというテストを書く

``` perl
is_deeply( [numsort(2, 3, 4, 0, 1)], [0, 1, 2, 3, 4], 'ランダムな数列をsortすると昇順に並ぶ' );
```
* 次に境界条件での振る舞いを検証するテストを書く

``` perl
is_deeply( [numsort()], [], '空配列をsortしたら空になる' );
is_deeply( [numsort(100)], [100], '1要素ならそのまま' );
```
* 例外条件についても確かめる

``` perl
ok( exception { [numsort('hoge')] },'文字をわたすと例外発生' );
```

## リファクタリング

* リファクタリングとは?
  * プログラムの振舞を変えずに実装を変更すること
* テストがなければ、外部機能の変更がないことを証明できない
  * テストがなければリファクタリングではない
* レガシーなコードに対してはどうする?
  * まずは、テストを書ける状態にしよう

* テストを書いてリファクタリングし、常に綺麗で保守しやすいコードを書きましょう

# ヒント

## ドキュメントを引きましょう
* perldoc perltoc 便利！
  * 定義済み変数 $_ @_ $@
    * perldoc perlvars を見るべし
* 正規表現
  * perldoc perlre
* 関数
  * perldoc -f open
  * http://perldoc.jp/ : perldocの日本語訳(バージョンに注意)
* CPANモジュール
  * perldoc LWP::UserAgent
  * https://metacpan.org/
* perldoc -t (日本語が文字化けしたら)

## 良い本を読みましょう
* はじめてのPerl
* 続・はじめてのPerl
* Perlベストプラクティス
  * Perl::Critic
* モダンPerl入門

## モジュールを使う
* App::cpanminus
  * CPAN モジュールをインストールする
    * Ruby における gem コマンドのようなもの
  * cpanm Some::Useful::Module
  * global な Perl にインストールされる
* Carton
  * プロジェクト毎の依存モジュール管理
    * Ruby における Bundler のようなもの
  * cpanm Carton すると carton コマンドが入る
  * cpanfile にモジュール一覧を書いて carton install
  * carton exec -- perl foo.pl と実行するとプロジェクトローカルにインストールしたモジュールが使える
  * perldoc cpanfile

## インタラクティブシェル

* perl -de0
* Reply
  * reply というスクリプトが入る
  * プラグイン機構があり .replyrc に色々書いてカスタマイズできる
* Eval::WithLexicals
  * tinyreplというスクリプトが入る
  * rlwrap と一緒に使うと楽です
* Devel::REPL
  * re.plというスクリプトが入る
  * Carp::REPL

## データの中身を見る

* Data::Dumper
* YAML
* etc.

``` perl
use Data::Dumper;

my $foo = {
    bar => 'bar',
    baz => [qw(hoge fuga)],
};

print Dumper $foo;

# $VAR1 = {
#           'bar' => 'bar',
#           'baz' => [
#                      'hoge',
#                      'fuga'
#                    ]
#         };
```

## プロジェクトのコードを書く心構え
* コードが読まれるものであることを意識する
  * あとから誰が読んでもわかりやすく書く
  * 暗黙のルールを知る => コードを読みまくる
* テストを書いて意図を伝える

## Perl まとめ
* Perlプログラミング勘所
* Perlによるオブジェクト指向プログラミング
* テストを書こう
* ヒント

* 今日かいて今日はまろう
  * と言っても時間はあまりないので無理せず

## Intern-Diary をつくろう

皆さんには、今日(2日目)から6日目までの5日の間でIntern-Diaryという日記サービスを作ってもらいます。
コードを書き始める前にこれから作成するソフトウェアの対象について分析し、設計を考えてみましょう。

### 要件をおさらいする
Intern-Diary でどういうことを実現したいかを改めて考えて箇条書きにしてみましょう。

### データモデリング

構築するソフトウェアにはどのような概念が登場するのか考えて分析してみましょう。

以下では Intern-Bookmark を例に考えてみます。

#### 登場する概念(モデル)

* `User` ブックマークをするユーザ
* `Entry` ブックマークされた記事(URL)
* `Bookmark` ユーザが行ったブックマーク

#### 概念が持つ特性
各クラスがどのような特性を持っているか考えてみましょう。

* User
  * ユーザの名前
* Entry
  * ブックマークされたURL
  * Webサイトのタイトル
* Bookmark
  * ブックマークしたUser
  * ブックマークしたEntry
  * コメント

#### 概念間の関係

![Inter-Bookmark](https://cdn-ak.f.st-hatena.com/images/fotolife/h/hakobe932/20140725/20140725163235.png)

* 1つのEntryには複数のBookmarkが属する (一対多)
* 1つのUserには複数のBookmarkが属する (一対多)

## 課題1

初日である今日は以下の課題に取り組んでもらいます。
各項目の説明を確認して取り組んでください。

### Intern-Diary を作ろう

1. データモデリング
2. モデリングに対応するオブジェクトの実装
3. テストに慣れる
4. 追加機能について考える(オプション)

### データモデリング

Intern-Bookmark のモデリングの講義を参考に簡単な日記システムを考えて、登場する概念(モデル)とその関係を考えてみましょう。
世の中の日記サービス・ブログサービスには様々な機能がありますが、ここでは基本的な機能に絞って考えてもらって構いません。

* 日記を書く人(=ユーザ)は存在しそうですね
* 普通の日記サービスであれば、ユーザごとに個別の日記がありますね
  * [はてな匿名ダイアリー](http://anond.hatelabo.jp) のようにユーザ個別の日記が存在しない日記サービスもあるにはありますね
* 日記には記事がありますね

講義で説明した「登場する概念(モデル)」と「概念が持つ特性」、「概念間の関係」についてテキストにまとめてください。
また、「概念間の関係」については図も描いてみてください。図については提出する必要はありませんが(含めてもらっても構いません)、メンターにチェックを受けて下さい。

### モデリングに対応するオブジェクトの実装

先の課題で考えたデータモデリングに基づくオブジェクトを実装してください。
どのようなデータモデリングを行ったかによって各モデルのできることは微妙に異なりますが、以下のようなことができるようにしてください。

* ユーザーは日記に記事を書くことができる
* 日記は記事の集合を返すことができる

プログラムのインターフェースは自由です。以下に Diary クラスと Entry クラス、 User クラスを用いたサンプルを記しますが、必ずしもこの通りになっている必要はありません。

本日の課題で書いてもらうコードそのものは翌日以降の課程では使いません。

```perl
use User;

my $user1 = User->new(name => 'John');

# Diary クラスのインスタンスが返る
my $diary = $user1->add_diary(
   name   => 'John の日記です',
);

print $diary->name; # John の日記です

# Entry クラスのインスタンスが返る
my $entry1 = $diary->add_entry(
   title => '日記だよ',
   body  => 'これが日記の本文だよ',
);
my $entry2 = $diaryg->add_entry(
   title => 'これも日記だよ',
   body  => 'やっぱり日記の本文だよ',
);

my $recent_entries = $diary->get_recent_entries;
print $recent_entries->[0]->body; # やっぱり日記の本文だよ
```

### テストに慣れる

「オブジェクトの実装」で実装したクラスの挙動についてのテストを記述してください。
テストの記述については今日の講義の教科書の内容や事前課題のテストなどを参考にしてください。

上記の例であれば、 Diary クラスと Entry クラス、 User クラスのそれぞれについてのテストを書く、ということになります。

### 追加機能について考える(オプション)

必須の課題が終わって時間に余裕がある場合は、上記の課題で作った日記に何らかの機能を追加してみてください。

機能を追加する場合は、追加する機能に対応するテストも実装してください。

追加機能の例を下記にあげます（ここにない機能でもOKです)
* コメント
* ページング
* 購読
* トラックバック
* リブログ

### 注意点

* できるだけテストスクリプトを書く(!!初日は__できるだけ__ではなくて必須です!!)
  * 少くとも動かして試してみることができないと、採点できません
  * 課題の本質的なところさえ実装すれば、外部モジュールで楽をするのはアリ
  * 何が本質なのかを見極めるのも課題のうち
* 余裕があったら機能追加してみましょう
* 講義および教科書から学んだことを課題に反映させよう
* きれいな設計・コードを心がけよう
  * 今日のコードは翌日以降の課程では使いませんが、翌日以降は自分の書いたコードに手を入れていくことになります

## 課題の提出方法

今日の課題は Intern-Diary リポジトリの basic_diary ディレクトリ以下にファイルを配置してください。
basic_diary ディレクトリの中にも簡単な説明が記載してあるのでそちらを参照してください。
