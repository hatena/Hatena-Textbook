# プログラミング言語 Swift

## 序文

Apple が例年開催する開発者向けカンファレンス WWDC は、iPhone の発表以降ことさらに注目が集まっている。その WWDC において、2014年に突然発表されたのが、新しいプログラミング言語 “Swift” である。

Swift は2010年に Apple の Chris Lattner によって開発が始められた。Chris Lattner は大学院において LLVM の開発を始め、Apple に雇われてからはさらに Clang プロジェクトを開始する。LLVM と Clang はその後の Apple プラットフォームにおける標準的なコンパイラの地位を占め、また OSS のコンパイラとして多くのプロジェクトに採用されている。Swift はその LLVM を活用した新しい言語である。

Apple は WWDC において Swift をいくつかの言葉で特徴付けた。“Modern” で “Safety” かつ “Fast”、そして “Interactive” である。それまで Apple プラットフォームで主に利用されてきた Objective-C と比較すればこれらの特長は明らかである。C 言語に拡張を施してオブジェクト指向プログラミング言語とした Objective-C と較べ、Swift ではクロージャや型推論、ジェネリクスなどの近代的な機能が大きく盛り込まれた。強い静的型付けであり、静的解析は多くの問題を事前に検知する。言語仕様や標準ライブラリは LLVM による最適化の恩恵を最大限に得られるように設計されている。そして Xcode との緊密な連携や、Playground に REPL など、インタラクティブに実行できる環境が用意された。

Swift はいまも開発が続けられている。2014年9月に1.0がリリースされてから、翌月に変更は少ないものの1.1となり、2015年4月には言語機能が拡張された1.2がリリースされている。現在は 2015年9月にリリースされた Swift 2 が最新である。このように活発な開発によって、言語仕様はつぎつぎと更新されており、今日学んだ知識は将来のアップデートで古びてしまうかもしれない。しかしそれでも Swift の根底にある思想について理解を深めることは、将来においても色褪せることのない資産である。本教科書がそのような学習の一助となることを願ってやまない。

## Swift の言語仕様

### Constants and variables

```swift
let name = "Steve"
var age = 56
print(name) // Steve
print(age) // 56
```

Swift では値を格納するために `let` 定数と `var` 変数を使う。`let` は一度初期化されると変更できず、`var` は再代入できる。変更を意図しない場合は必ず `let` を使う。

上記の例では `name` は `String` 型、`age` は `Int` 型に推論される。このため `age` に `Int` 型でないものを再代入することはできない。

グローバル関数 `print` を利用して値を出力できる。

行中の `//` 以降はコメントになる。また `/*` から `*/` で囲まれた部分もコメントになる。

```swift
var age: Int = 56
```

型は変数名に続けて `:` で区切って記述する。

Swift ではコンパイラによって型推論が行われるので、基本的には必要な場合にのみ型を記述する。以下の例でも `age` は `Int` に推論されるため、意味は同じである。

```swift
var age = 56
```

> #### Ref.
>
> - [The Swift Programming Language — Language Guide — The Basics — Constants and Variables](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/TheBasics.html#//apple_ref/doc/uid/TP40014097-CH5-ID310)

> #### Column - `print`
>
> `print(_:)` 関数は標準出力に値を出力する。このときデフォルトでは最後に改行が入る。`print(_:terminator:)` という終端の文字を制御できる関数があり、第二引数を空文字にすることで改行を抑制できる。
>
> `print` は文字列以外の値でも出力できるが、出力される内容は `Streamable` `CustomStringConvertible` `CustomDebugStringConvertible` の3つの protocol のどれかを実装していればそれが利用される。複数実装している場合には左記の順で利用される。一般的には `CustomStringConvertible` に準拠するのがよい。またデバッグ中に利用することを目的とした `debugPrint` のために `CustomDebugStringConvertible` を実装してもよい。

> #### Ref.
>
> - [Swift Standard Library Reference — Swift Standard Library Functions Reference — print](https://developer.apple.com/library/ios/documentation/Swift/Reference/Swift_StandardLibrary_Functions/index.html#//apple_ref/swift/func/s:FSs5printFTGSaP__9separatorSS10terminatorSS_T_)

### Literal

Swift には何種類かのリテラルがある。

#### 数値

```swift
let decimal = 21
let binary = 0b10101 // 二進数
let octal = 0o25 // 八進数
let hexadecimal = 0x15 // 十六進数
```

```swift
let decimal = 1.618
let exponent = 161.8e-2 // 常用対数
```

数値には上記の例のように、`Int` 型の整数リテラルと、`Double` 型の浮動小数点数リテラルがある。`1_000_000` のように、桁数がわかりやすいように間に `_` を入れてもよい。

> #### Ref.
>
> - [The Swift Programming Language — Language Guide — The Basics — Numeric Literals](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/TheBasics.html#//apple_ref/doc/uid/TP40014097-CH5-ID323)

#### 真偽値

```swift
let iAmAwesome = true
let weAreStupid = false
```

真偽値リテラルは `true` か `false` で、これらは `Bool` 型の値である。

> #### Ref.
>
> - [The Swift Programming Language — Language Guide — The Basics — Booleans](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/TheBasics.html#//apple_ref/doc/uid/TP40014097-CH5-ID328)

#### 文字列

```swift
let myName = "Steve"
print("My name is \(myName)")
```

文字列リテラルは `String` 型の値を作る。文字列リテラル中で `\()` で囲われた変数はその値が補間される。

`let` で宣言された文字列は変更できない。文字列を操作したい場合は `var` で宣言された文字列を使う。

> #### Ref.
>
> - [The Swift Programming Language — Language Guide — Strings and Characters — String Literals](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/StringsAndCharacters.html#//apple_ref/doc/uid/TP40014097-CH7-ID286)

> #### Column - `StringInterpolationConvertible`
>
> 文字列に `\()` で値を補間する機能は、`String` が準拠する `StringInterpolationConvertible` の機能である。独自にこれを実装することでカスタマイズすることもできる。

#### nil

```
let phoneNumber: String? = nil
```

`nil` リテラルは後述する `Optional.None` 値を表す。

この他に後述する配列リテラルと辞書リテラルが存在する。

> #### Column - `LiteralConvertible`
>
> リテラルはそれぞれに対応する `LiteralConvertible` protocol を持つ。列挙すると `IntegerLiteralConvertible` `FloatLiteralConvertible` `BooleanLiteralConvertible` `StringLiteralConvertible` `NilLiteralConvertible` `ArrayLiteralConvertible` `DictionaryLiteralConvertible` `UnicodeScalarLiteralConvertible` `ExtendedGraphemeClusterLiteralConvertible` となる。後ろのふたつは文字列に関するリテラルの特殊形である。
>
> `LiteralConvertible` protocol に準拠することで、それぞれのリテラルから初期化できるようになる。そのひとつの例は標準のコレクション型である `Set` で、これは `ArrayLiteralConvertible` に準拠しているため Array リテラルから初期化できる。ただし Array リテラルだけが書かれている場合は型推論によって Array 型になる。必ず `Set` 型であると決まっている場合にだけ Array リテラルが利用できる。

### Optional

Swift には値が存在しないことを示す `nil` が用意されている。`nil` はリテラルであり、`Optional` 型の `None` という値になる。このため `nil` は `Optional` 型の定数や変数にのみ格納できる。

```swift
var phoneNumber: Optional<String> = nil
```

このとき `Optional<String>` は、`String` 型の値または `nil`、という意味になる。`<String>` は後述するジェネリクスにおける型パラメータである。また上記のコードは `?` を使って以下のようにも書くことができ、一般的にはこちらを使う。

```swift
var phoneNumber: String? = nil
```

Optional な変数に初期値を与えなかった場合は自動的に `nil` になる。

Optional 型として宣言された変数の値を確かめたいときは unwrap する必要がある。

```swift
var phoneNumber: String? = "090-1234-5678"
if phoneNumber != nil {
    print("The phone number is existing \(phoneNumber!)")
}
```

Optional 型の変数の後ろに `!` をつけることで forced unwrap でき、`String` 型の値が得られる。ただしこのとき実際には `nil` だった場合は実行時エラーになりプログラムはクラッシュする。

上記のように事前に `nil` でないことを検査するために、Optional Binding という構文が用意されている。

```swift
var phoneNumber: String? = "090-1234-5678"
if let number = phoneNumber {
    print("The phone number is existing \(number)")
}
```

このように書くと `phoneNumber` が `nil` ではないときだけブロックが実行され、またこのときブロック内では unwrap された `String` 型の値 `number` が利用できる。

```swift
var phoneNumber: String? = "090-1234-5678"
if phoneNumber?.hasPrefix("090") ?? false {
    print("The phone number is handheld")
}
```

Optional 型の変数のメソッドなどを呼び出すとき、`?` に続けて呼び出すことができる。このとき Optional が `nil` の場合は何も起きず、値があるときだけ実際にメソッドが呼び出される。メソッドの返り値が存在する場合は Optional に wrap される。従って `phoneNumber?.hasPrefix()` は `Bool?` を返す。これを Optional Chaining と呼ぶ。

また二項演算子 `??` は、左辺の値が `nil` の場合に右辺の値を返す。結果として `phoneNumber?.hasPrefix("090") ?? false` は、左辺値が nil であっても `false` が返るので、全体としては `Bool` 型の値を返すことになる。

このように値が `nil` かどうかをケアしたくないとき、`ImplicitlyUnwrappedOptional` 型を利用することができる。`ImplicitlyUnwrappedOptional<String>` は `String!` と書ける。

```swift
var phoneNumber: String! = "090-1234-5678"
print("The phone number is existing \(phoneNumber)")
```

Implicitly Unwrapped Optional として宣言したものが `nil` だった場合は、メソッドを呼び出した場合などに実行時エラーになる。このような変数は、動的に値が代入されるために初期値として `nil` を取らざるを得ないが、利用時には事実上 `nil` ではないことが明らか（仮に `nil` になっていたらプログラムがクラッシュしても仕方ない）、という場合に利用できる。

> #### Ref.
>
> - [The Swift Programming Language — Language Guide — The Basics — Optionals](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/TheBasics.html#//apple_ref/doc/uid/TP40014097-CH5-ID330)
> - [The Swift Programming Language — Language Guide — Optional Chaining](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/OptionalChaining.html#//apple_ref/doc/uid/TP40014097-CH21-ID245)
> - [Swift Standard Library Reference — Optional Enumeration Reference](https://developer.apple.com/library/ios/documentation/Swift/Reference/Swift_Optional_Enumeration/index.html#//apple_ref/swift/enum/s:Sq)

> #### Column - `enum Optional`
>
> Optional 型は、実際には enum である。`enum Optional<T>` は `case None` と `case Some(T)` のふたつの case を持つ。`NilLiteralConvertible` に準拠しており、nil リテラルで初期化された場合は `Optional.None` となり、値が存在する場合には `Optional.Some` となる。これが Optional 型の実態である。
>
> `enum Optional` は便利なメソッドを持っている。`map` と `flatMap` は、Some の場合には引数のクロージャを評価して値を返す。None の場合はただ nil を返す。

### Tuple

タプルは複数の値を一度にやりとりするための仕組みである。

```swift
let steve = ("Steve Jobs", 56)
let (name, age) = steve
print(steve.0)
```

`(String, Int)` のように任意の型で任意の個数の値を持つことができる。また `steve.0 // "Steve Jobs"` のようにインデックスで個々の要素にアクセスできる。

```swift
let steve = (name: "Steve Jobs", age: 56)
print(steve.age)
```

個々の要素にラベルをつけることもできる。

タプルの要素数と型はコンパイル時に決まる。要素数が変わる場合には後述する Array が利用できる。より複雑な構造を取り扱う場合には struct を使うべきである。

> #### Ref.
>
> - [The Swift Programming Language — Language Guide — The Basics — Tuples](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/TheBasics.html#//apple_ref/doc/uid/TP40014097-CH5-ID329)

### Collection types

現在の Swift には Array, Dictionary, Set の3つのビルトインされたコレクション型がある。

それぞれ `let` で宣言されているとき、要素を変更することはできない。変更したい場合は `var` を使う。

#### Array

`Array` は順序付けられた任意の個数の値を格納するデータ構造である。`Array<Int>` のように、特定の型の要素だけを格納する。またこれは `[Int]` と書ける。

```swift
let fishes = ["Mackerel", "Saury", "Sardine"]
print(fishes[0])
```

Array は `[VALUE1, VALUE2]` のような Array リテラルで初期化できる。上記の例では `fishes` は `[String]` 型であると推論される。個々の要素には `fishes[0]` のように subscript でアクセスできる。subscript によるアクセスでは、Array の要素数を超えてアクセスしようとすると実行時エラーが発生する。`fishes.first` のようにアクセスすると、要素が Optional で返り、実行時エラーは起きない。

```swift
for fish in fishes {
    print(fish)
}
```

すべての要素について処理を行いたい場合は `for...in` が利用できる。処理は Array の要素の順序通りに行われる。

```swift
var dogs: [String] = []
dogs.append("Shiba")
```

`let` で宣言された Array は変更できないが、`var` で宣言された Array は変更できる。

> #### Ref.
>
> - [The Swift Programming Language — Language Guide — Collection Types — Arrays](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/CollectionTypes.html#//apple_ref/doc/uid/TP40014097-CH8-ID107)
> - [Swift Standard Library Reference — Array Structure Reference](https://developer.apple.com/library/ios/documentation/Swift/Reference/Swift_Array_Structure/index.html#//apple_ref/swift/struct/s:Sa)

#### Set

`Set` は特定の型の値の集合を表すデータ構造である。`Set<Int>` のように型を表現する。Array と異なり要素の順序は保持されない。また同一の要素は必ずひとつである。

```swift
let fishes: Set<String> = ["Mackerel", "Saury", "Sardine"]
if fishes.contains("Mackerel") {
    print("A Revolutionary New Kind of Application Performance Management")
}
```

Set もまた Array リテラルで初期化できる。ただし型アノテーションなどによって Set であることが推論できなければならない。

```swift
for fish in fishes {
    print(fish)
}
```

すべての要素について処理を行いたい場合は `for...in` が利用できる。Set では順序が不定である。

> #### Ref.
>
> - [The Swift Programming Language — Language Guide — Collection Types — Sets](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/CollectionTypes.html#//apple_ref/doc/uid/TP40014097-CH8-ID484)
> - [Swift Standard Library Reference — Set Structure Reference](https://developer.apple.com/library/ios/documentation/Swift/Reference/Swift_Set_Structure/index.html#//apple_ref/swift/struct/s:VSs3Set)

#### Dictionary

`Dictionary` は特定の型のキーと特定の型の値を組み合わせとして保持するデータ構造である。キーと値のふたつの型をあわせて `Dictionary<String, Int>` のように表現する。またこれは `[String : Int]` と書ける。

```swift
let sizeOfFishes = [
    "Mackerel" : 50,
    "Saury"    : 35,
    "Sardine"  : 20,
]

if let mackerelSize = sizeOfFishes["Mackerel"] {
    print("Generally, Mackerel growth \(mackerelSize) cm.")
}
```

Dictionary は `[KEY1 : VALUE1, KEY2 : VALUE2]` のような Dictionary リテラルで初期化できる。上記の例では `sizeOfFishes` は `[String : Int]` に推論される。Dictionary の個々の要素に対しては subscript によって `sizeOfFishes["Mackerel"]` のようにキーを用いてアクセスできる。このとき返ってくるのは `Int?` 型であり、キーが存在しない場合の値は `nil` である。

```swift
for (fish, size) in sizeOfFishes {
    print("Generally, \(fish) growth \(size) cm.")
}
```

すべての要素について処理を行いたい場合は `for...in` が利用できる。それぞれの要素がキーと値のタプルで得られる。順序は不定である。

キーとして用いる型は `protocol Hashable` に準拠している必要がある。

> #### Ref.
>
> - [The Swift Programming Language — Language Guide — Collection Types — Dictionaries](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/CollectionTypes.html#//apple_ref/doc/uid/TP40014097-CH8-ID113)
> - [Swift Standard Library Reference — Dictionary Structure Reference](https://developer.apple.com/library/ios/documentation/Swift/Reference/Swift_Dictionary_Structure/index.html#//apple_ref/swift/struct/s:VSs10Dictionary)

### Operators

Swift にはいくつもの演算子がある。

#### 代入演算子

`=` は代入演算子で、左辺の変数などに右辺の値を代入する。

#### 算術演算子

`+` `-` `*` `/` は両辺に数値をとって計算したり、文字列を結合したりする。

`%` は剰余演算子で、剰余を求める。剰余演算子は浮動小数点数の計算にも用いることができる。

`++` や `--` といった単項のインクリメント/デクリメントの演算子は、前置でも後置でも使うことができる。前置した場合は返り値が演算後の値となり、後置した場合は返り値が演算前の値となる。

単項の `-` 演算子は数の正負を反転させる。この演算子と後に続く数との間に空白を入れてはならない。対称性のために単項の `+` 演算子も用意されている。

#### 複合代入演算子

`+=` などの複合代入演算子が利用できる。

#### 比較演算子

`==` `!=` `>` `<` `>=` `<=` といった比較演算子が利用できる。

`==` や `!=` で同値性を検査するためには `protocol Equatable` に準拠している必要がある。またそれ以外の比較演算子で順序を検査するには、`protocol Equatable` に加えて `protocol Comparable` に準拠する必要がある。Protocol に関しては後述する。

`===` や `!==` 演算子を用いると、参照型の値について同一のインスタンスを指し示しているか検査できる。参照型に関しても後述する。

#### 三項条件演算子

```swift
var anyBoolean: Bool!
...
let someValue: Int
if anyBoolean {
    someValue = 1
} else {
    someValue = 0
}
```

上記のような条件分岐を `?:` を用いて以下のように書ける。

```swift
let someValue = anyBoolean ? 1 : 0
```

#### nil 結合演算子

```swift
var optionalInt: Int?
...
let someValue: Int
if optionalInt != nil {
    someValue = optionalInt!
} else {
    someValue = 0
}
```

上記のように Optional の値が `nil` でなければそれを採用し、`nil` なら別な値を採用するというとき、`??` 演算子を用いると以下のように書ける。

```swift
let someValue = optionalInt ?? 0
```

このように左辺が Optional 型であるとき、左辺の値が `nil` なら右辺の値を採用する。

#### 範囲演算子

`...` や `..<` は範囲演算子である。`0...3` は `0, 1, 2, 3` の値を含む範囲を作る。`0..<3` の場合は `0, 1, 2` の値の範囲となる。それぞれ `Range<Int>` 型となる。

#### 論理演算子

単項で前置の `!` は否定演算子である。後に続く真偽値を反転させる。

`&&` と `||` は二項の論理演算子で、それぞれ論理積と論理和である。

> #### Ref.
>
> - [The Swift Programming Language — Language Guide — The Basics — Basic Operators](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/BasicOperators.html#//apple_ref/doc/uid/TP40014097-CH6-ID60)

> #### Column - Advanced Operators
>
> Swift にはこの他にもビット演算子が用意されており、ビット単位NOT `~`、ビット単位AND `&`、ビット単位OR `|`、ビット単位XOR `^` や、算術ビットシフト `>>` `<<` がある。
>
> Swift の数値は、加算や減算、乗算において算術オーバーフローが起きる場合にはランタイムエラーになる。このような整数値の演算においてオーバーフローをエラーにするのではなく、そのままオーバフローさせたい場合にはオーバーフロー演算子 `&+` `&-` `&*` を利用できる。
>
> 演算子には結合順がある。結合順はドキュメントを参照。
>
> 新たに定義した型においても既存の演算子を使えるようにするためには、演算子と同名のグローバル関数を定義する。`func + (left: MyType, right: MyType) -> MyType` というような関数を定義することで、算術演算子 `+` が利用できる。
>
> さらにまったく独自の演算子を作ることもできる。詳細はドキュメントを参照。

> - [Swift Standard Library Reference — Swift Standard Library Operators Reference](https://developer.apple.com/library/ios/documentation/Swift/Reference/Swift_StandardLibrary_Operators/index.html#//apple_ref/doc/uid/TP40016054)
> - [The Swift Programming Language — Language Guide — The Basics — Advanced Operators](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AdvancedOperators.html#//apple_ref/doc/uid/TP40014097-CH27-ID28)

### Control flow

Swift のコントロールフローはおおよそ C 言語に由来するものの、しかし実態としては大きく拡張されている。

`if` 文などの条件式は、必ず真偽値を返さなければならない。またパターンマッチなどの高度な機能が数多く提供されている。

#### Switch

`switch` 文では、ある値をパターンマッチで分類して処理をわけることができる。

```swift
let theNumber: UInt = 42

switch theNumber {
case 0..<10:
    print("Single digit")
case 10..<100:
    print("Double digits")
case 100..<1000:
    print("Triple digits")
default:
    print("Very large")
}
```

Swift では上位の条件にマッチするとき下位の条件の処理は実行されない。下位にもマッチさせたい場合は `fallthrough` 文を書く。`fallthrough` 文を書くと、下位の条件に関係なく処理が実行される。

`case` はすべての場合を網羅している必要がある。ただしどの `case` にも当てはまらない場合の `default` の処理を書くことができる。またどの場合も必ずひとつ以上の式が必要である。何も処理したくない場合は便宜的に `break` 文を書くことが多い。

個々の `case` はパターンマッチによって評価される。パターンマッチによってマッチするかどうかは、`~=` という二項演算子の結果が利用される。

```swift
let pair: (String?, String?) = ("Steve", "Bill")

switch pair {
case let (a?, b?):
    print("\(a) and \(b)")
case let (a?, _):
    print(a)
case let (_, b?):
    print(b)
case (_, _):
    print("No man")
}
```

上記の例のように、タプルの要素が `Optional.Some` かどうかで分岐することもできる。`Some` の場合を特別に `a?` のように書ける。どのような値でも構わない場合は `_` と書く。

`case` には `where` 節をつけることもできる。

#### For-In

```swift
for i in 0..<3 {
    print(i)
}
```

`for...in` 文を利用してすべての要素を列挙することができる。このとき列挙される対象となる集合は `protocol SequenceType` に準拠している必要がある。

```swift
for i in 0..<3 where i % 2 == 0 {
    print(i)
}
```

`for...in` 文には `where` 節が利用でき、`where` 節を評価して真になる場合にのみ実行する、という記述ができる。

```swift
let numbers: [Int?] = [0, nil, 3, 4, nil]
for case let i? in numbers {
    print(i)
}
```

`case` キーワードを用いてパターンマッチできる。上記のように `nil` を含む `[Int?]` のような Array のうち `nil` を除いた値について処理する、といったことができる。

`continue` を用いて次のループの実行に移ることができる。また `break` を用いてループの実行をすべて終えることができる。

#### For

```swift
for var i = 0; i < 3; ++i {
    print(i)
}
```

同様のループは C 言語などでも見られるようなカウンタを用いた `for` 文でも記述できる。

`continue` を用いて次のループの実行に移ることができる。また `break` を用いてループの実行をすべて終えることができる。

#### While

```swift
var i = 0
while i < 3 {
    print(i)
    ++i
}
```

`while` 文でも同様のことができる。

`continue` を用いて次のループの実行に移ることができる。また `break` を用いてループの実行をすべて終えることができる。

```swift
var integer: UInt32? = 0
while case let i? = integer {
    print(i)
    let random = arc4random_uniform(10)
    integer = random != 0 ? random : nil
}
```

`case` キーワードを用いてパターンマッチできる。

#### Repeat-While

```swift
var i = 0
repeat {
    print(i)
    ++i
} while i < 3
```

最低でも一度は実行する場合には `repeat-while` 文が利用できる。他言語における `do-while` と同様である。

`continue` を用いて次のループの実行に移ることができる。また `break` を用いてループの実行をすべて終えることができる。

#### If

```swift
let fish = "Mackerel"
if fish == "Mackerel" {
    print("The fish is Mackerel")
} else if fish == "Saury" {
    print("The fish is Saury")
} else {
    print("The fish is unknown")
}
```

`if` 文では条件によって異なる処理を行える。

```swift
let number = 1
if case 0..<3 = number {
    print(number)
}
```

`case` キーワードを用いてパターンマッチできる。

```swift
let condition = true
let aNumber: Int? = 3
let anotherNumber: Int? = 7
if condition, let a = aNumber, let b = anotherNumber where a < b {
    println(a + b)
}
```

また複数の Optional Binding を組み合わせることができる。

#### Do

```swift
do {
    let name = "John"
    print("Hello \(name)")
}

let name = "Taylor"
print("Hello again \(name)")
```

`do` はスコープを作る。後述する Error Handling と組み合わせて使われることが多い。

> #### Ref.
>
> - [The Swift Programming Language — Language Guide — The Basics — Control Flow](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/ControlFlow.html#//apple_ref/doc/uid/TP40014097-CH9-ID120)

### Functions

```swift
func multiply(number: Int, by: Int) -> Int {
    return number * by
}
let fifteen = multiply(3, by: 5)
```

Swift の関数定義は `func` キーワードを用いる。`func 関数名(引数名: 引数型, 引数名: 引数型) -> 返り値型 { 実装 }` が基本的なフォーマットである。呼び出し時には引数にラベルをつける。ただし第一引数にはラベルをつけない。

複数の値を返したい場合にはタプルにまとめるとよい。

引数の名前は外部引数名と内部引数名にわけることができる。

```swift
func multiply(number first: Int, by second: Int) -> Int {
    return first * second
}
multiply(number: 3, by: 5)
```

引数名の部分を空白で区切り、外部引数名・内部引数名の順に書く。外部引数名は呼び出し時のラベルになり、内部引数名は実装中で使う名前である。外部引数名として `_` を使うと、呼び出し時のラベルがなくなる。

返り値がないときは返り値の型を `Void` とすることで示せる。省略してもよい。

関数は、関数名やラベル、引数の型、返り値の型などを合わせてシグネチャを形成する。シグネチャが異なる関数は別な関数となる。このことを利用して、関数名は同じだが引数や返り値の型は異なる関数を定義することができ、これをオーバーロードと呼ぶ。オーバーロードされた関数は、引数や返り値の型から呼び出される関数が決まる。

#### 引数

```swift
func increment(var number: Int) -> Int {
    return ++number
}
increment(6)
```

関数の引数は `let` と同様に変更できないが、明示的に `var` とすることで変更可能になる。

```swift
func increment(inout number: Int) {
    ++number
}
var number = 7
increment(&number) // => 8
```

`inout` キーワードを使うことで受け取った変数の参照に対して変更を行える。関数の中で書き換えられる変数は、そのことを示すために `&` を前置して渡す必要がある。

この例において `inout` としなかった場合には、関数に渡された値はコピーされたものとみなせるので、変更を加えても関数の外側には影響しない。

```swift
func increment(var number: Int) {
    ++number
}
var number = 7
increment(number) // => 7
```

#### 引数のデフォルト値

```swift
func refrain(string: String, count: UInt=1) -> String {
    var result: [String] = []
    for i in 0..<count {
        result.append(i == 0 ? string : string.lowercaseString)
    }
    return result.joinWithSeparator(", ")
}

refrain("Let it be", count: 3)

refrain("Love")
```

引数にはデフォルト値を設定することができ、デフォルト値の設定された引数は呼び出し時に省略できる。

#### 可変長引数

```swift
func sum(numbers: Int...) -> Int {
    return numbers.reduce(0, combine: +)
}
sum(1, 4, 7)
```

型名に続いて `...` と書くと可変長の引数を受けられるようになる。実装中においては Array として取り扱うことができる。

#### 関数型

関数も型を持つ。関数が `func multiply(number first: Int, by second: Int) -> Int` という定義であれば、その型は `(Int, Int) -> Int` である。

```swift
func multiply(number first: Int, by second: Int) -> Int {
    return first * second
}

var calculation: (Int, Int) -> Int

calculation = multiply

let twentyOne = calculation(3, 7)
```

従って関数を指し示す変数を作ることもできる。

ここで、関数を返す関数を定義できることがわかる。

```swift
func multiply(number: Int, by: Int) -> Int { return number * by }
func add(number: Int, to: Int) -> Int { return number + to }

func calculation(kind: String) -> (Int, Int) -> Int {
    switch kind {
    case "add":
        return add
    case "multiply":
        return multiply
    default:
        fatalError("Unsupported")
    }
}

calculation("add")(1, 4)
```

また関数はネストすることができるので、上記の例は下のようにも書ける。

```swift
func calculation(kind: String) -> (Int, Int) -> Int {
    func multiply(number: Int, by: Int) -> Int { return number * by }
    func add(number: Int, to: Int) -> Int { return number + to }

    switch kind {
    case "add":
        return add
    case "multiply":
        return multiply
    default:
        fatalError("Unsupported")
    }
}

calculation("add")(1, 4)
```

#### guard

`guard` は関数の early exits をサポートする構文である。

```swift
let contact = [ "name" : "Steve Jobs", "mail" : "steve@apple.com" ]

func recipient(contact: [String: String]) -> String? {
    guard let name = contact["name"], let mail = contact["mail"] else {
        return nil
    }

    return "\(name) <\(mail)>"
}

recipient(contact)
```

`guard` に続けて `if` 文のように必要な条件を記述し、`else` 節でそれが充足されなかったときの処理を書く。`else` 節では必ず `return`, `break`, `continue`, `throw` のいずれかまたは `@noreturn` 関数の呼び出しを行う必要がある。

`guard let` のように定数や変数を作ると、同じスコープのそれ以降で利用できる。

> ##### Column `@noreturn`
>
> 関数には `@noreturn` 属性を付与することができる。この属性のついた関数を呼び出しても呼び出し元には戻らないことを表す。例えば C 標準ライブラリの `@noreturn func exit(_:)` がそうであるように、一般的にはプログラムの終了を引き起こすような関数に付与される。
>
> 実用的な事例としては、文字列を返す関数の実装中で、何らかの条件によっては何も返す値がないとき、`@noreturn` 属性のついている `fatalError` 関数を呼び出すことでコンパイルを通すことができる。単に返り値を Optional にするかまたは `throw` することもできるが、もしそれが存在し得ないような条件であれば（あるいはそのような状況がすでに回復不可能なエラーのとき）、このような方法で関数のインターフェースをシンプルに保てる。

> #### Ref.
>
> - [The Swift Programming Language — Language Guide — The Basics — Functions](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Functions.html#//apple_ref/doc/uid/TP40014097-CH10-ID158)

### Closures

クロージャは関数オブジェクトの一種である。引数以外の変数をクロージャが定義されたコンテキストからキャプチャする。また関数はクロージャの特殊形である。

`CollectionType` の `map` に与える引数は、要素の型の引数を一つとり、任意の型の値を返り値とする関数である。

```swift
func doubling(number: Int) -> Int {
    return 2 * number
}

let values = [0, 1, 2, 3, 4, 5]

values.map(doubling)
```

これはクロージャを使って以下のようにも書ける。

```swift
let values = [0, 1, 2, 3, 4, 5]

values.map({ (number: Int) -> Int in
    return 2 * number
})
```

このように `in` の前に引数名や型、返り値の型を書く。

このとき、クロージャの引数 `number` が `Int` 型であることは自明であり、返り値が `Int` であることは `return` から推論できる。さらに単数行のクロージャであれば、その処理がそのまま返り値になる。

```swift
values.map({ number in 2 * number })
```

このことで上記のようにも書いても曖昧さがなく、コンパイルできる。またクロージャの引数は順に `$0` `$1` `$2` とも書けるようになっている。これによって以下のように書ける。

```swift
values.map({ 2 * $0 })
```

さらに関数の最後の引数がクロージャのときは丸括弧の外に書ける。他に引数がなければ括弧も省略できる。

```swift
values.map { 2 * $0 }
```

#### キャプチャ

```swift
func counter() -> () -> Int {
    var count = 0
    let closure = {
        return ++count
    }
    return closure
}

let c = counter()
c()
c()
```

このような `counter` 関数が返すクロージャは、評価される度に値を1つ増やして返す。`closure` が `var count` をキャプチャしており、`c: () -> Int` 変数がこれを保持しているためである。

後述するメソッドにおいて、自身のメソッドをクロージャの中から呼び出したいとき、キャプチャする対象を明らかにするために `self.method()` としなければならず、`self.` を省略できない。

```swift
let c2 = c
c2()
```

クロージャは参照型なので上記のように新たな変数に代入しても同じ状態を共有する。

> #### Column `@noescape`, `@autoclosure`
>
> クロージャには即時に評価されるものと遅延して評価されるものがある。例えば `filter` 関数に渡されたクロージャであれば必ずその時点で評価されるだろうし、ネットワーク通信のコールバックであれば通信が終わってから評価されるだろう。このとき遅延して評価されるクロージャは、その実装中で参照する外部環境を保存する。Swift ではこれを escape と呼ぶ。もしクロージャが即時に評価されると決まっていれば escape は不要である。escape しなくてよいなら、`self.` を省略でき、またパフォーマンスも多少改善される。Swift では受け取ったクロージャを即時に実行する関数に `func someFunc(@noescape closure: () -> Void)` といった形で `@noescape` 属性を付けられる。
>
> クロージャを受け取る関数は、そのクロージャを評価しても評価しなくてもよい。このため特定の条件に当てはまる場合にだけ必要な値を得るのに、その値を返すクロージャを受け取るようにすることができる。もし必要なければクロージャを評価しないことでパフォーマンスを改善できるかもしれない。このようなユースケースのために `@autoclosure` 属性があり、関数の引数にこの属性をつけることができ、この属性がつけられた引数に渡す値は自動的にクロージャに変わる。例えば `func someFunc(@autoclosure parameter: () -> String)` という関数に `someFunc("A" + "B")` という風に引数を与えることができ、このとき `"A" + "B"` は呼び出し時には評価されず、関数の内部でクロージャを評価したときに実際に評価される。実際に `??` 演算子はこの属性を活用しており、`func ??<T>(optional: T?, @autoclosure defaultValue: () -> T) -> T` という定義になっている。左辺値が nil でなければ右辺を評価しない短絡評価はこのように実装されている。
>
> `@autoclosure` はデフォルト状態では `@noescape` と同じように escape されない。もし escape が必要な、すなわち即時に評価しないような場合には `@autoclosure(escaping)` とアノテートする必要がある。

> #### Ref.
>
> - [The Swift Programming Language — Language Guide — The Basics — Closures](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Closures.html#//apple_ref/doc/uid/TP40014097-CH11-ID94)

### Value types

Swift には値型として enum と struct がある。

#### Enumerations

`enum` で列挙型を表現できる。

```swift
enum ArithmeticOperation {
    case Add
    case Substract
    case Multiply
    case Divide
}
```

enum は associated value を持つことができる。

```swift
enum Diagram {
    case Line(Double)
    case Rectangle(Double, Double)
    case Circle(Double)
}

func calculateArea(diagram: Diagram) -> Double {
    let area: Double
    switch diagram {
    case .Line(_):
        area = 0.0
    case let .Rectangle(width, height):
        area = width * height
    case .Circle(let radius):
        area = radius * radius * M_PI
    }
    return area
}

calculateArea(.Circle(3.0))
```

パターンマッチで associated value を取得して処理できる。

enum は raw value を持つこともできる。

```swift
enum Month: Int {
    case January = 1, February, March, April, May, June, July, August, September, October, November, December
}

if let april = Month(rawValue: 4) {
    print(april.rawValue)
}
```

`String`、`Character`、整数型、浮動小数点型が raw value になり得る。raw value が設定されている場合は raw value から初期化できる。

`enum` や `case` に `indirect` を前置することで associated value が間接的に格納される。これにより再帰的なデータ構造を作ることができる。

```swift
enum List<T> {
    case Nil
    indirect case Cons(head: T, tail: List<T>)
}
```

#### Structures

`struct` は構造体型をつくる。

```swift
struct Body {
    let height: Double
    let mass: Double
}

let myBody = Body(height: 129.3, mass: 129.3)

func calculateBodyMassIndex(body: Body) -> Double {
    let meterHeight = body.height / 100.0
    return body.mass / (meterHeight * meterHeight)
}

calculateBodyMassIndex(myBody)
```

`let` で宣言された変数の値は、その内部の property が `let` であっても `var` であっても変更できない。変更したい場合は `var` を用いる。

Optional でない型の property の値をその宣言順に指定することで初期化できる。

#### Value type

値型の変数はその間で状態を共有しない。値を変数に代入したり関数に引数として渡したりしたときに、その内容がコピーされたと見なすことができる。（実際にコピーが起きるかどうかは文脈や最適化などの結果に左右され、原則的には copy on write となっている。しかしこれを意識する必要はほとんどない。）

> Ref.
>
> - [The Swift Programming Language — Language Guide — The Basics — Enumerations](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Enumerations.html#//apple_ref/doc/uid/TP40014097-CH12-ID145)
> - [The Swift Programming Language — Language Guide — The Basics — Classes and Structures](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/ClassesAndStructures.html#//apple_ref/doc/uid/TP40014097-CH13-ID82)

### Reference types

参照型の値は、変数間で同じ状態を共有する。

#### Classes

class は参照型の型を作る。参照型であるから、変数への代入や関数の引数として渡してもコピーされず、同じ状態が共有される。

class は struct と似ているが、後述する継承などの機能を有する。またメモリ管理上の特性も異なる。

```swift
class Lot {
    var remains: [String]

    init(_ elements: String...) {
        self.remains = elements
    }

    func choose() -> String? {
        if remains.isEmpty {
            return nil
        }
        let randomIndex = Int(arc4random_uniform(UInt32(remains.count)))
        return remains.removeAtIndex(randomIndex)
    }
}

func pickFromLot(lot: Lot, count: Int) -> [String] {
    var result: [String] = []
    for _ in (0..<count) {
        lot.choose().map { result.append($0) }
    }
    return result
}

let lot = Lot("Swift", "Objective-C", "Java", "Scala", "Perl", "Ruby")
pickFromLot(lot, count: 3)
lot.remains
```

> #### Ref.
>
> - [The Swift Programming Language — Language Guide — The Basics — Classes and Structures](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/ClassesAndStructures.html#//apple_ref/doc/uid/TP40014097-CH13-ID82)

#### Automatic Reference Counting

参照型の値は参照カウント方式のメモリ管理が行われる。より具体的には、必要なタイミングで参照カウントを増減させる処理がコンパイル時に自動で挿入される。参照カウントが1以上あるとき（参照がひとつでもあるとき）インスタンスはメモリ上に保持され、参照カウントが0になったタイミングで破棄される。これを Automatic Reference Counting (ARC) と呼ぶ。例えば変数にインスタンスへの参照が格納されるとき参照カウントは1増え、その変数がスコープを外れるとき参照カウントは1減る。

ここで、二つのインスタンスが互いを参照し合うなどといった際に、永遠に参照カウントが0にならないということが起き得る。これを循環参照という。循環参照が起きるとメモリリークするので、一方を弱い参照（参照カウントに影響しない参照）にしてやる必要が出てくる。

```swift
class Dog {
}

weak var dog: Dog?
dog = Dog()
```

`weak` キーワードを付与すると変数は弱い参照になる。弱い参照の変数は必ず Optional である。弱い参照の変数として保持しているインスタンスが解放された場合は、即座に変数の値が `nil` となる。

```swift
unowned var dog: Dog
dog = Dog()
```

同様に `unowned` キーワードでも弱い参照を作ることができる。インスタンスが解放されても `nil` にならないが、解放後にアクセスすると実行時エラーになる。Implicitly Unwrapped Optional に近い挙動をする。

さらに、クロージャはキャプチャした参照型の値について強い参照を持っている。これも循環参照の原因となり得る。このためクロージャにおいても、必要に応じて `weak` や `unowned` の弱い参照にする必要がある。

```swift
let dog = Dog()

let callDog = { [weak dog] (message: String) -> String in
    return "\(dog!), \(message)."
}

callDog("stay")
```

Swift には上記のように、クロージャがキャプチャする変数について参照の強さを変更できるシンタックスが用意されている。

> #### Ref.
>
> - [The Swift Programming Language — Language Guide — The Basics — Automatic Reference Counting](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html#//apple_ref/doc/uid/TP40014097-CH20-ID48)

### Properties and methods

値型や参照型は変数や定数、関数を持つことができる。

#### Properties

型はそれに関連する変数を持つことができる。これをプロパティと呼ぶ。

プロパティには stored プロパティと computed プロパティがある。

##### Stored Properties

Stored プロパティは `let` や `var` で値を保持する。enum はこれを持つことができない。

```swift
class Dog {
    var name: String?
}

let dog = Dog()
dog.name = "Pochi"
```

`lazy` キーワードを付けることで遅延初期化できる。

```swift
class DataFormatter {
    var format: String = ""
}

class DataPrinter {
    lazy var formatter = DataFormatter()
    var data: [String] = []
}

let printer = DataPrinter()
```

`lazy` で宣言された stored プロパティは実際にアクセスされるまで初期化されない。最初にアクセスされたタイミングで初期化される。生成コストが高いオブジェクトなどを使う場合に用いることができる。

##### Computed Properties

Computed プロパティでは他の情報から計算可能な値をプロパティとして提供できる。

```swift
struct Circle {
    var radius: Double = 0.0

    var area: Double {
        get {
            return pow(radius, 2) * M_PI
        }
        set (newArea) {
            radius = sqrt(newArea / M_PI)
        }
    }
}
```

`get` `set` でアクセッサを提供することで computed プロパティとなる。`set` の `newArea` の部分は、何も指定しなければ自動的に `newValue` となる。また `set` を提供せず、`get` だけのときはブロックを省略できる。

```swift
struct Body {
    let height: Double
    let mass: Double

    var bodyMassIndex: Double {
        let meterHeight = height / 100.0
        return mass / (meterHeight * meterHeight)
    }
}

Body(height: 129.3, mass: 129.3).bodyMassIndex
```

##### Property Observers

`willSet` や `didSet` ブロックを書くことで、プロパティの値の変化の前後に何らかの処理を行うことができる。

```swift
struct Dam {
    let limit = 100.0
    var waterLevel = 0.0 {
        willSet {
            print("\(newValue - waterLevel) will change")
        }
        didSet {
            if waterLevel > limit {
                print("Bursted")
                waterLevel = limit
            }
            print("\(waterLevel - oldValue) did change")
        }
    }
}

var dam = Dam()
dam.waterLevel = 120
```

特に別名を付けなければ `newValue` や `oldValue` で変更の前後の値を得ることができる。また `didSet` で値を別な値に変えることができる。初期値が設定される際には処理は行われない。

##### Type Properties

`let` や `var` の前に `static` を付けることでタイププロパティとなり、そのプロパティは同じ型の値の間で共有される。

> #### Ref.
>
> - [The Swift Programming Language — Language Guide — The Basics — Properties](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Properties.html#//apple_ref/doc/uid/TP40014097-CH14-ID254)

#### Methods

プロパティと同様に、型は関数を持つことができる。これをメソッドと呼ぶ。

メソッドの実装では `self` キーワードで自身を参照できる。文脈上で対象が明確であれば `self` は省略可能である。

```swift
class Printer {
    var numberOfCopies = 1

    func put(string: String) {
        for _ in (0..<self.numberOfCopies) {
            print(string)
        }
    }
}

let printer = Printer()
printer.put("Word")
```

##### Mutating Methods

値型では内部の状態を変更するようなメソッドには `mutating` キーワードを付ける必要がある。

```swift
struct StepCounter {
    var count: Int = 0

    mutating func step() {
        count++
    }
}

var counter = StepCounter()
counter.step()
counter.count
```

`enum` の場合は `self` に直接代入することで状態を変更する。

```swift
enum ToggleSwitch {
    case On
    case Off

    mutating func toggle() {
        switch self {
        case .On:
            self = .Off
        case .Off:
            self = .On
        }
    }
}

var electricSwitch = ToggleSwitch.Off
electricSwitch.toggle()
```

##### Type Methods

`static` を付けることでタイプメソッドとなる。タイプメソッドの実装では `self` はその型そのものを指す。

> #### Ref.
>
> - [The Swift Programming Language — Language Guide — The Basics — Methods](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Methods.html#//apple_ref/doc/uid/TP40014097-CH15-ID234)

#### Subscripts

Array や Dictionary はスクエアブラケット（`[]`）によって要素にアクセスできる。`subscript` を実装することで任意の型について同様の機能を提供できる。

```swift
struct OddNumbers {
    subscript(index: Int) -> Int {
        return index * 2
    }
}

let odds = OddNumbers()
odds[3]
```

Computed プロパティと同様に、get のみ、または get と set の両方を提供できる。また引数は複数あってもよい。

> #### Ref.
>
> - [The Swift Programming Language — Language Guide — The Basics — Subscripts](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Subscripts.html#//apple_ref/doc/uid/TP40014097-CH16-ID305)

### Inheritance

class は継承することでサブクラスを作ることができる。class 名の右に `:` に続けてスーパークラスを指定する。

サブクラスは継承元のスーパークラスの機能を利用できる。スーパークラスの実装を明示的に参照する場合は `super` キーワードを利用できる。

```swift
class Animal {
    func bark() {
    }
}

class Dog: Animal {
    override func bark() {
        print("Bark")
    }
}

let pochi: Animal = Dog()
pochi.bark()
```

メソッドをオーバーライドするときは `override` キーワードで修飾する必要がある。

`final` キーワードを `class` や `func` に前置することで、継承やオーバーライドを制限できる。

### Initializers and deinitializers

#### Initializers

class や struct や enum を初期化するイニシャライザを定義できる。イニシャライザでは、Optional ではなくデフォルト値が設定されていない全ての stored プロパティを初期化する必要がある。Optional の場合は指定されなければ `nil` になる。

```swift
struct Length {
    let meter: Double

    init(meter: Double) {
        self.meter = meter
    }

    init(yard: Double) {
        self.meter = yard / 0.9144
    }
}

Length(yard: 245.6)
```

イニシャライザは複数定義することができる。また第一引数からラベルを明示する。

イニシャライザが一つも定義されておらず、かつイニシャライザで初期化するべき stored プロパティが存在しないとき、class はデフォルトで空のイニシャライザを持つ。また struct の場合は、イニシャライザが一つも定義されていない場合に全ての初期化すべき stored プロパティを定義順に指定するデフォルトのイニシャライザを持つ。

##### 値型のイニシャライザ

値型の場合は `self.init` で自身のイニシャライザを呼び出すことができる。stored プロパティに初期値を与える以外の初期化処理を行っている場合、そのイニシャライザを呼び出すことでコードの重複を避けられる。

##### 参照型のイニシャライザ

class は少なくとも1つの designated イニシャライザを持つ。designated イニシャライザは class の初期化処理の全てを担う。このようなイニシャライザは少ないほどよい。また designated イニシャライザに加えて convenience イニシャライザを定義できる。`convenience` 修飾子を前置することで convenience イニシャライザとなり、内部的に designated イニシャライザを呼び出す。

class が別の class を継承している場合、サブクラスの designated イニシャライザは必ずスーパークラスの designated イニシャライザを呼び出さなければならない。convenience イニシャライザは自身の class の designated イニシャライザを呼び出さなければならない。

サブクラスの designated イニシャライザは、サブクラスで追加された stored プロパティを初期化してからスーパークラスの designated イニシャライザを呼び出し、その後に必要であれば継承した stored プロパティを初期化しなければならない。convenience イニシャライザは自身の designated イニシャライザを呼び出さなければならない。このプロセスの後にはじめてその他の `self` を参照するような処理を行える。

基本的には、サブクラスはスーパークラスのイニシャライザを継承しない。またスーパークラスの designated イニシャライザと同様のイニシャライザを定義する場合、`override` 修飾子が必要である。ただしサブクラスが新たに導入した stored プロパティが全てデフォルト値を持つ場合は自動的にスーパークラスのイニシャライザが使える場合がある。サブクラスが designated イニシャライザを定義していない場合、スーパークラスの designated イニシャライザが利用できる。またサブクラスがスーパークラスの designated イニシャライザを全て実装している場合（継承によるものであっても）、スーパークラスの convenience イニシャライザが利用できる。

`required` 修飾子をイニシャライザに前置することで、サブクラスにそのイニシャライザの実装を強制することができる。

##### Failable Initializers

イニシャライザは与えられた引数によって初期化を失敗させることができる。

```swift
struct Tweet {
    let message: String

    init?(message: String) {
        guard message.characters.count <= 140 else {
            return nil
        }
        self.message = message
    }
}

if let tweet = Tweet(message: "Hello there") {
    print(tweet.message)
}
```

イニシャライザを `init?` とすると、初期化を失敗させたいケースで nil を返すことができる。このようなイニシャライザは Optional を返したことになる。

> #### Ref.
>
> - [The Swift Programming Language — Language Guide — The Basics — Initialization](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Initialization.html#//apple_ref/doc/uid/TP40014097-CH18-ID203)

#### Deinitializers

class のインスタンスが破棄されるときに実行したい処理をデイニシャライザを用いることで実装できる。

```swift
deinit {
    // Deinitialization
}
```

> #### Ref.
>
> - [The Swift Programming Language — Language Guide — The Basics — Deinitialization](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Deinitialization.html#//apple_ref/doc/uid/TP40014097-CH19-ID142)

### Casting

インスタンスの型を調べるためには `is` を使う。`is` は真偽値を返すので `if some is SomeType {}` のように使える。

アップキャストするには `as` を使う。ダウンキャストするときは `as!` または `as?` を使う。`as!` はキャストに失敗するとランタイムエラーになる。`as?` は Optional を返し、キャストに失敗すると nil になる。

```swift
class File {
    var filename: String

    init(filename: String) {
        self.filename = filename
    }
}

class SwiftFile: File {
    func compile() -> File {
        return File(filename: filename + ".output")
    }
}

class Xcode {
    var sources: [File] = []

    func build() {
        for source in sources {
            var compiled: [File] = []
            if let swift = source as? SwiftFile {
                compiled.append(swift.compile())
            } else {
                compiled.append(source)
            }
        }
    }
}
```

> #### Ref.
>
> - [The Swift Programming Language — Language Guide — The Basics — Type Casting](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/TypeCasting.html#//apple_ref/doc/uid/TP40014097-CH22-ID338)

### Protocols

protocol は、class や struct や enum が実装しなければならないインターフェースを規定する。参照型や値型を特定のプロトコルに準拠させるためには、その protocol で定められたインターフェースを実装する必要がある。

```swift
protocol FileSystemItem {
    var name: String { get }
    var path: String { get }

    init(directory: Directory, name: String)

    func copy() -> Self
}

struct File: FileSystemItem {
    var name: String {
        return split(path.characters){ (char) -> Bool in char == "/" }.last.map { String($0) } ?? ""
    }
    let path: String

    init(path: String) {
        self.path = path
    }

    init(directory: Directory, name: String) {
        self.init(path: directory.path + name)
    }

    func copy() -> File {
        return File(path: path + " copy")
    }
}

struct Directory: FileSystemItem {
    var name: String {
        return split(path.characters){ (char) -> Bool in char == "/" }.last.map { String($0) } ?? ""
    }
    let path: String

    init(path: String) {
        self.path = path
    }

    init(directory: Directory, name: String) {
        self.init(path: directory.path + name + "/")
    }

    func copy() -> Directory {
        return Directory(path: path[path.startIndex..<(path.endIndex.predecessor())] + " copy/")
    }
}

let bin = Directory(path: "/usr/bin/")
let swift = File(directory: bin, name: "swift")
```

protocol は `protocol` で宣言できる。protocol ではプロパティやメソッドのほか、イニシャライザや subscript を宣言できる。

プロパティは `{ get }` や `{ get set }` のように、変更可能かどうかを表すことができる。プロパティの実装は stored プロパティでも computed プロパティでもよい。

メソッドは実装のない宣言だけの状態で記述する。例のように `Self` キーワードを使うことで、型をその protocol を実装した型に限定できる。また `mutating` 修飾をつけることもできる。

イニシャライザや subscript もおおよそメソッドと同様である。

protocol は継承することができ、`protocol SomeProtocol: AnotherProtocol` という形で書ける。また protocol に準拠できる型を class に限定することができ、`protocol SomeProtocol: class` と宣言する。

protocol は型として振る舞うので、定数や変数、引数や返り値の型として用いることができる。複数の protocol に適合していることを `protocol<SomeProtocol, AnotherProtocol>` と表現できる。protocol は他の型のように、`is` や `as` によってチェックできる。

> #### Ref.
>
> - [The Swift Programming Language — Language Guide — The Basics — Protocols](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Protocols.html#//apple_ref/doc/uid/TP40014097-CH25-ID267)

### Extensions

extension を用いることで既存の型に機能を追加することができる。追加できるのは computed プロパティやメソッド、イニシャライザや subscript である。stored プロパティを増やすことはできない。

```swift
extension String {
    var isHiragana: Bool {
        return unicodeScalars.reduce(!isEmpty) { (result, unicode) -> Bool in
            return result && 0x3040 <= unicode.value && unicode.value < 0x30A0
        }
    }
}

"こんにちは".isHiragana
```

このように任意の型を拡張することができる。

extension 型を何らかの protocol に適合するように拡張することができる。`extension Something: SomeProtocol` のように書ける。

#### Protocol Extensions

extension は protocol も拡張できる。

```swift
protocol Hiraganable {
    var isHiragana: Bool { get }
}

extension String: Hiraganable {
    var isHiragana: Bool {
        return unicodeScalars.reduce(!isEmpty) { (result, unicode) -> Bool in
            return result && 0x3040 <= unicode.value && unicode.value < 0x30A0
        }
    }
}

extension CollectionType where Generator.Element : Hiraganable {
    var isHiragana: Bool {
        return reduce(!isEmpty) { (result, string) -> Bool in
            return result && string.isHiragana
        }
    }
}

["あいうえお", "かきくけこ"].isHiragana
```

上記の例では `protocol CollectionType` を拡張している。また `where` 節によって条件を指定することができ、この場合は `CollectionType` の個々の要素が protocol に適合しているか確認している。

> ### Ref.
>
> - [The Swift Programming Language — Language Guide — The Basics — Extensions](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Extensions.html#//apple_ref/doc/uid/TP40014097-CH24-ID151)

### Error handling

Swift にはエラー処理のための特別な機構が用意されている。

```swift
enum NetworkError: ErrorType {
    case Unreachable
    case UnexpectedStatusCode(Int)
}

func getResourceFromNetwork() throws -> String {
    let URL = "http://www.hatena.ne.jp/"
    if !checkConnection(URL) {
        throw NetworkError.Unreachable
    }
    let (statusCode, response) = connectHTTP(URL, method: "GET")
    if case (200..<300) = statusCode {
        return response
    } else {
        throw NetworkError.UnexpectedStatusCode(statusCode)
    }
}

do {
    let res = try getResourceFromNetwork()
    print(res)
} catch NetworkError.Unreachable {
    print("Unreachable")
} catch NetworkError.UnexpectedStatusCode(let statusCode) {
    print("Unexpected status code \(statusCode)")
} catch {
    print("Unknown problem")
}
```

エラーは `protocol ErrorType` に適合する型の値として表される。必要に応じて付加的な情報を与えることもできる。

ハンドリングされるべき問題が起きた場合は定義されたエラーを `throw` する。エラーを `throw` する関数には、その宣言に `throws` キーワードを付加する必要がある。

`throws` で宣言された関数を呼び出す場合には必ず `try` を前置する。

実際にはエラーが発生しないことがわかっている場合には `try!` と書くことで、エラーをハンドリングしないことを明示できる。ただし `try!` としているにも関わらずエラーが発生した場合はランタイムエラーとなる。またエラーが起きたとしても単に無視したい場合には `try?` と書くことができ、返り値がある場合は Optional になる。エラーが起きてもなにも起こらず、返り値は nil になる。

`try` した関数を `do` ブロックで囲い、`catch` 節を付けることでエラーをハンドリングできる。catch 節では `ErrorType` の型にマッチさせることで特定のエラーについて処理できる。このとき何も指定しないデフォルトの catch 節が存在しない場合には、網羅的にエラーがハンドリングされたとは見なされない。

網羅的にエラーがハンドリングされない場合はエラーは伝播する。すなわち、throws する関数を呼び出す関数は、網羅的にエラーをハンドリングできなければその関数自身にも throws キーワードが必要である。

```swift
enum MyError: ErrorType {
    case DangerousError
}

func modify(string: String, @noescape closure: (string: String) throws -> String) rethrows -> String {
    return try closure(string: string)
}

do {
    try modify("ABC") { str -> String in
        throw MyError.DangerousError
    }
} catch {
    print(error)
}

modify("ABC") { str -> String in
    str + str
}
```

エラーを `throws` するクロージャを受け取って実行する関数が、そのクロージャの内部で発生するエラー以外にはいかなるエラーも `throw` しない場合には、`throws` ではなく `rethrows` と書くことができる。このとき、引数として渡すクロージャでエラーが発生しないことがわかっていれば、エラーについての処理をする必要がない。

#### defer

関数の最後に必ず実行したい処理がある場合、`defer` 文を利用することができる。

```swift
func queryDataBase() throws {
    let db = DataBaseHandler()
    defer {
        db.disconnect()
    }
    try db.connect()

    // Query
}
```

defer 文のブロックに実装された処理は、関数を `return` などで正常に抜ける場合でも、あるいは `throw` によって強制的に脱出する場合でも、必ず実行されることが保証される。

> #### Ref.
>
> - [The Swift Programming Language — Language Guide — The Basics — Error Handling](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/ErrorHandling.html#//apple_ref/doc/uid/TP40014097-CH42-ID508)

### Generics

特定の型とは紐付かない一般的な API を提供したい場合に、ジェネリクスの機能が使える。

```swift
class LotInt {
    var remains: [Int]

    init(_ elements: Int...) {
        self.remains = elements
    }

    func choose() -> Int? {
        if remains.isEmpty {
            return nil
        }
        let randomIndex = Int(arc4random_uniform(UInt32(remains.count)))
        return remains.removeAtIndex(randomIndex)
    }
}

class LotString {
    var remains: [String]

    init(_ elements: String...) {
        self.remains = elements
    }

    func choose() -> String? {
        if remains.isEmpty {
            return nil
        }
        let randomIndex = Int(arc4random_uniform(UInt32(remains.count)))
        return remains.removeAtIndex(randomIndex)
    }
}
```

上記の例は、それぞれ整数型と文字列型に対して利用できる「くじ引き」class である。これらは整数型や文字列型の機能を利用せず、まったく同じ機能を提供するが、型が異なるために別な実装になっている。

`Any` 型を利用してこれを回避することもできるが、返り値の型が不明確になり、利用する側でキャストする必要がある。

```swift
class ConsumptionLot<Item> {
    var remains: [Item]

    required init(_ items: Item...) {
        self.remains = items
    }

    func choose() -> Item? {
        if remains.isEmpty {
            return nil
        }
        let randomIndex = Int(arc4random_uniform(UInt32(remains.count)))
        return remains.removeAtIndex(randomIndex)
    }
}

let lot = ConsumptionLot("A", "B", "C")
lot.choose()
```

Swift ではジェネリクスを用いて、上記のように記述できる。`<Element>` のように型パラメータを定義し、それぞれ関連する部分をこれで置き換えている。上例のような利用時には `Element` は `String` に特殊化される。初期化時に `ConsumptionLot<String>("A", "B", "C")` と書くこともできるが、今回は引数の型から型推論できるので省略されている。

Swift では Array や Dictionary や Set といったコレクション型や、あるいは Optional 型など、多くの場面でジェネリクスが利用されている。

型パラメータは class などの型と共に宣言することもできるが、関数と共に宣言することもできる。その場合は `func someFunction<T>()` となる。

#### Associated types and type constraints

protocol には関連する型を定義する機能がある。以下の例のように `typealias ItemType` などとしてこれを宣言し、これに準拠する側では `typealias ItemType = Item` として型を指定する。

```swift
protocol LotType {
    typealias ItemType
    var remains: [ItemType] { get }
    init(_ items: ItemType...)
    func choose() -> ItemType?
}

class ConsumptionLot<Item>: LotType {
    typealias ItemType = Item

    var remains: [Item]

    required init(_ items: Item...) {
        self.remains = items
    }

    func choose() -> Item? {
        if remains.isEmpty {
            return nil
        }
        let randomIndex = Int(arc4random_uniform(UInt32(remains.count)))
        return remains.removeAtIndex(randomIndex)
    }
}

class ConsumptionlessLot<Item>: LotType {
    typealias ItemType = Item

    var remains: [Item]

    required init(_ items: Item...) {
        self.remains = items
    }

    func choose() -> Item? {
        if remains.isEmpty {
            return nil
        }
        let randomIndex = Int(arc4random_uniform(UInt32(remains.count)))
        return remains[randomIndex]
    }
}

func pickItemsFrom<Lot: LotType>(lot: Lot, count: Int) -> [Lot.ItemType] {
    var result: [Lot.ItemType] = []
    for _ in (0..<count) {
        lot.choose().map { result.append($0) }
    }
    return result
}

let lot = ConsumptionlessLot("A", "B", "C", "D")
pickItemsFrom(lot, count: 3)
```

このようにすることで何らかの protocol を引数に取る関数などにおいてもその型を抽象化できる。

型パラメータには制約を設けることができる。`<Type: SomeProtocol>` のように、ある protocol に準拠していることを求めたり、ある class を継承していることを求めたりできる。

さらに `where` 節をつけることで `<Lot: LotType where LotType.ItemType: Equatable>` などのように関連する型についても制約を与えることができる。

> #### Ref.
>
> - [The Swift Programming Language — Language Guide — The Basics — Generics](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Generics.html#//apple_ref/doc/uid/TP40014097-CH26-ID179)

### Access control

Swift にはアクセスコントロールのための3つのスコープがある。`public` は完全に公開され、どこからでもアクセスできる。`internal` はモジュール内部からだけアクセスできる。`private` はそのファイル内からだけアクセスできる。デフォルトは `internal` である。

Swift によるアプリケーションは、モジュールという可視性の単位を持つ。Framework や アプリケーションそのものがモジュールを成す。Framework はライブラリを作成する際の単位となる。外部のモジュールの機能を利用する場合はモジュールの名前を使って `import SomeModule` と書く。

Swift によるもう一つの可視性の単位はファイルである。異なる class などであっても、同一ファイル内であれば同じ単位である。

```swift
public class ConsumptionLot<Item> {
    public private(set) var remains: [Item]

    public required init(_ items: Item...) {
        self.remains = items
    }

    public func choose() -> Item? {
        if remains.isEmpty {
            return nil
        }
        let randomIndex = Int(arc4random_uniform(UInt32(remains.count)))
        return remains.removeAtIndex(randomIndex)
    }
}
```

アクセスコントロール修飾子は class などの宣言やプロパティ、メソッド、イニシャライザなど、ほとんどの箇所に前置できる。またプロパティの setter へのアクセスを禁止したい場合には `private(set)` のような書き方ができる。

#### アクセスコントロールとテスト

テストを書くとき、テストコードは別のモジュールになるため、テスト対象のモジュールの `public` の部分しか見えないことになる。公開されているインターフェースのみをテストするという発想からはこれで十分にも思われるが、実際的には内部状態を検証したり、あるいは内部で利用されているメソッドをオーバーライドしたモックオブジェクトを作りたいといった需要もある。

import 時に `import SomeModule` を `@testable import SomeModule` と書けるようになり、`internal` にもアクセスできる。ただしビルド時の設定で `Enable Testability` を有効にする必要があり、また最適化などが行われないようにデバッグ設定にする必要がある。

> #### Ref.
>
> - [The Swift Programming Language — Language Guide — The Basics — Access Control](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AccessControl.html#//apple_ref/doc/uid/TP40014097-CH41-ID3)

### Availability

実行されるプラットフォームやバージョンによって利用できない関数などを表すために `@available` 属性が利用できる。

`@available(iOS 8.0, OSX 10.10, *)` などとすることで、利用できるプラットフォームやバージョンを示すことができる。プラットフォームの名前は現在のところ `iOS` `iOSApplicationExtension` `OSX` `OSXApplicationExtension` `watchOS` がある。最後の `*` は将来において登場する可能性のある新たなプラットフォームへの対応を示す。

このほか `unavailable` や `introduced=` `deprecated=` `obsoleted=` `message=` `renamed=` といった付加的な情報を括弧の中に加えることができる。

これを利用して `if #available() {}` のように、プラットフォームやバージョンに応じた分岐を書くことができる。

```swift
@available(iOS 9.0, *)
func someFunction() {
    print("iOS 9 or later")
}

if #available(iOS 9.0, *) {
    someFunction()
}
```

> #### Ref.
>
> - [The Swift Programming Language — Language Reference — Attributes](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Attributes.html#//apple_ref/doc/uid/TP40014097-CH35-ID347)
> - [The Swift Programming Language — Language Guide — The Basics — Control Flow](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/ControlFlow.html#//apple_ref/doc/uid/TP40014097-CH9-ID523)

## Cocoa や Objective-C との連携

Swift は Apple プラットフォームにおける新しい標準的なプログラミング言語として、既存の Cocoa フレームワークやプログラミング言語 Objective-C と連携できるように配慮されている。

### Objective-C

Objective-C は C 言語にオブジェクト指向のパラダイムを取り入れようと拡張された言語である。動的な特性を持つことが特徴的である。

Objective-C の class は Swift からもそのまま利用できる。イニシャライザは Swift のイニシャライザとして呼び出せるようになり、またファクトリーメソッドもイニシャライザとして使えるようになる。プロパティやメソッドも基本的には Swift から利用できる。

Objective-C では `id` 型という全てのオブジェクトを表す型があり、Swift では `AnyObject` 型がこれに対応する。Objective-C ではすべてのオブジェクトは `NSObject`（または `NSProxy`）を継承していなければならない。Swift にはこのような制約はなく、明示的に `class Some: NSObject` としない限りは継承しない。`NSObject` の持つ機能を利用したい場合は注意が必要である。

`NSString` や `NSArray`、`NSDictionary`、`NSSet` といった基本的な class は、Swift においてはそれぞれ `String`、`Array`、`Dictionary`、`Set` といった対応する型に変換される。

Objective-C では `NSArray` などのデータ構造に任意の class のインスタンスを格納でき、Swift のように型の制約がない。すなわち Swift からは多くの場合 `[AnyObject]` のように見える。ただし lightweight generics の機能によって、Objective-C の側で `NSArray<NSString *> *lines` などとなっていれば `lines: [String]` に見える。

Objective-C の型には Optional のように nil を区別する方法がない。`_Nullable` や `_Nonnull` のようなアノテーションが付けられている場合は、Swift から見たときにもそれが反映される。Objective-C の側にそういったアノテーションがなければ、ImplicitlyUnwrappedOptional 型になる。

#### Objective-C から Swift のコードを利用する

Swift で書かれていても、`NSObject` を継承した class は Objective-C からそのまま利用できる。

`@objc` 属性は属性値をつけることで Objective-C 側から見える名前を変えることができる。例えば Objective-C にはネームスペースが存在しないため数文字のプリフィックスを付けることがあるが、`@objc(HTNBookmark) class Bookmark` とすることで Swift からは `Bookmark` クラスでも Objective-C からは `HTNBookmark` クラスにする、といったことができる。class に限らずメソッド名なども変えられる。

`@objc` によって Objective-C に公開したインターフェースは、Objective-C の動的な特性によって Swift と同じようにオーバーロードできない。その場合でもメソッドに `@nonobjc` 属性をつけて Objective-C 側から呼び出せないようにすることで、オーバーロードしたメソッドを作ることができる。

### 属性

#### Interface Builder

Xcode の Interface Builder 機能と連携するために `@IBOutlet` や `@IBAction`、`@IBDesignable` や `@IBInspectable` といった属性が使える。

#### `@NSCopying`

Objective-C ではプロパティに `copy` 属性をつけることで、プロパティへオブジェクトをセットするときにコピーが行われるようにできた。Swift では `@NSCopying` 属性をプロパティにつけることでこれを再現できる。

#### `@NSManaged`

Core Data を利用する場合に、`NSManagedObject` のサブクラスはランタイムに生成されるプロパティやメソッドを持つ。Swift では `@NSManaged` 属性をつけることで、そういったプロパティやメソッドを表現できる。

> #### Ref.
>
> - [Using Swift with Cocoa and Objective-C](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/BuildingCocoaApps/index.html#//apple_ref/doc/uid/TP40014216-CH2-ID0)


<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/2.1/jp/"><img alt="クリエイティブ・コモンズ・ライセンス" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/2.1/jp/88x31.png" /></a><br />この 作品 は <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/2.1/jp/">クリエイティブ・コモンズ 表示 - 非営利 - 継承 2.1 日本 ライセンスの下に提供されています。</a>
