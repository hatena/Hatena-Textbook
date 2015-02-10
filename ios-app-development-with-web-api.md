# Web API を利用する iOS アプリ作成

iOS 開発 Bootcamp

## Introduction

スマートフォン全盛期のいま、Web サービスもスマートフォンから利用される割合がどんどん高まっています。ユーザーはより便利で快適なアプリを求め、Web サービス事業者はそういったユーザーを少しでも満足させるため、日々努力しています。またスマートフォンアプリ開発を専業としていても、Web との関わりのないアプリではできることが非常に少なく、その様なアプリはいまやごくまれです。今日、Web アプリケーションとスマートフォンアプリは非常に密接な関係にあります。

Web アプリケーションとスマートフォンアプリ開発の両方を学ぶことは、そういった現在の Web をより広く見通すためには最適な課題であると言えます。どちらも学ぶことでその連関を知るだけでなく、開発の類似性や違いからより多くを学べるはずです。

そこで今回は2日間で、Web アプリケーションと連携した iOS アプリ開発を学びます。iOS アプリ開発は、Web アプリケーション開発と似ている部分も多いですが、新しい概念もたくさんあります。ぎりぎりの量を詰め込んだので、意識を高めてがんばって取り組んでください。

---

## Swift 言語

Swift は Apple が開発した Objective-C に代わる新しい言語です。2014年6月に開催された WWDC 2014 において発表されました。iOS や OS X のアプリケーションの開発を目的として開発されています。このため Cocoa あるいは Cocoa Touch といった既存のフレームワークを利用できるように設計されています。また Swift は LLVM によってコンパイルされることを前提として開発され、このため LLVM の強力な最適化の恩恵を受けることができます。

動的な特徴を持っていた Objective-C と較べ、Swift は多分に静的な言語になりました。このことでプログラムが安全になるほか、LLVM による最適化が行われやすくなります。静的型付けであることに加えて Swift ではモダンな言語仕様を広く取り入れ、名前空間のサポートや型推論、ジェネリクスといった言語仕様を導入しました。これらの結果としてコンパイラの強力なチェック機構が効果的に利用できるようになりました。

これらの大きな改善の反面、これまでの Objective-C の動的な特性を利用していたパラダイムの多くは Swift のオブジェクトでは利用できません。オブジェクトが Objective-C の `NSObject` を基底クラスとしているか、あるいは純粋な Swift のオブジェクトなのかによって挙動が違います。また Swift が C 言語との互換性を持たないことで、C++ 言語との相互的なやり取りができなくなりました。これは Objective-C において Objective-C++ として利用できていたものです。

現在 (2014年8月時点) の Swift は開発途上のものであり、今後どのように Swift の言語仕様が拡充され、あるいは Swift の影響でこれまでのパラダイムにどういった変化が起きるのかまだ分かりません。Cocoa や Cocoa Touch の Objective-C で書かれてきたフレームワークがどうなっていくのかも定かではありません。サードパーティーのライブラリもほとんどが Objective-C で書かれています。今後一定の期間をかけて、Swift らしいパラダイムを利用したものに置き換わっていくのかもしれませんが、おそらくそれにはもう少し時間がかかるでしょう。

以上のことから本テキストではこの後、専ら Objective-C について記載します。Swift が発表されたいまもなお、Objective-C に関する十分な知識は役に立ちます。しかしエンジニアであれば当然新しい言語である Swift に興味を持つでしょう。今日現在において Swift を学びたければ、Apple のドキュメントが最も役立つことでしょう。

[Swift – Overview – Apple Developer](https://developer.apple.com/swift/)

## Objective-C 言語

C 言語にオブジェクト指向の機能を取り入れるため Smalltalk 由来のいろいろを合体した言語ですが、とはいえ基本は C 言語です。まずは C 言語の部分を確認します。

```objc
NSInteger number = 5; // => 5
number = 8; // => 8
number = number + 4; // => 12
number = number / 3; // => 4
number -= 4; // => 0
```

このようなプリミティブ型や、配列、構造体といった複合型など、C 言語的なデータを一通り扱うことができます。

制御文についても C 言語で使われるものが使えます。

```objc
void hello() {
    print("Hello");
}

BOOL flag = YES;
if (flag) {
    hello();
}

for (NSUInteger i = 0; i < 10; i++) {
    hello();
}
```

このように C 言語の機能が一通り使えます。しかし iOS に含まれるライブラリの多くは Objective-C を前提として作られています。C 言語はそれが必要とされる場面でのみ使うことになります。ここからはプログラミング言語としての Objective-C を見ていきます。

### 基本的なオブジェクト

まず基本的なオブジェクトを紹介します。`NSObject *object;` はオブジェクトへの参照です。新しいインスタンスを作るには `NSObject *object = [[NSObject alloc] init];` とします。

#### 基底クラス

```objc
NSObject *object = [[NSObject alloc] init];
id another = [[NSObject alloc] init];
```

基底クラスは `NSObject` または `NSProxy` ですが、普段は `NSObject` だけ気にしていたらよいです。`NSObject` または `NSProxy` のポインタを表す `id` 型というのもよく出てきます。`id` 型は任意のオブジェクトを表すとき使われます。

> [NSObject Class Reference](https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSObject_Class/Reference/Reference.html)
>
> [NSObject Protocol Reference](https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Protocols/NSObject_Protocol/Reference/NSObject.html)

#### 文字列

```objc
NSString *message = @"Hello";
NSLog(@"%@ world", message);
```

文字列は `NSString` または `NSMutableString` を使います。`@""` で囲うリテラルが使えます。

> [NSString Class Reference](https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/Reference/NSString.html)
>
> [NSMutableString Class Reference](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFMutableStringRef/Reference/reference.html)

#### 数値

```objc
NSNumber *times = @(24);
NSLog(@"%@ times", times);
NSInteger timesInt = [times integerValue];
```

数値は `NSNumber` で、様々な大きさの整数や浮動小数点数、真偽値などを格納できます。リテラル表記では `@()` で囲います。ポインタや構造体を格納するための `NSValue` というのもあり、たまに使われます。

> [NSNumber Class Reference](https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSNumber_Class/Reference/Reference.html)

#### 配列

```objc
NSArray *messages = @[@"Hello", @"Good morning", @"Goog afternoon"];
NSLog(@"%@", messages);
NSString *firstMessage = messages[0];
NSLog(@"%@", firstMessage);
```

配列には `NSArray` または `NSMutableArray`。`@[]` というリテラルがあります。

> [NSArray Class Reference](https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSArray_Class/NSArray.html)
>
> [NSMutableArray Class Reference](https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSMutableArray_Class/Reference/Reference.html)

#### 辞書

```objc
NSDictionary *messagesToFriends = @{
    @"Tom" : @"Nice to meet you.",
    @"Steve" : @"RIP",
    @"Sam" : @"Hi.",
};
NSString *friend = @"Steve";
NSString *message = messagesToFriends[friend];
NSLog(@"%@ %@", message, friend);
```

辞書は `NSDictionary` または `NSMutableDictionary`。リテラルは `@{}` です。

> [NSDictionary Class Reference](https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSDictionary_Class/NSDictionary.html)
>
> [NSMutableDictionary Class Reference](https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSMutableDictionary_Class/Reference/Reference.html)

#### NULL

```objc
id object;
object = NULL;
object = nil;
object = [NSNull null];
```

`NULL` を表す値が3つあります。C 言語的な `NULL` と Objective-C 的な `nil` は、いずれも NULL ポインタです。`NSNull` は `NSObject` を継承するオブジェクトです。`NSDictionary` などのコレクションに値として格納するために使います。`NSNull` のインスタンスを真偽値として評価すると真になるので、`if` 文などでは適切に取り扱う必要があります。

> [NSNull Class Reference](https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSNull_Class/Reference/Reference.html)

　

> #### コラム - iOS / OS X のフレームワーク
>
> iOS / OS X アプリ開発においては、OS の提供する標準フレームワークを上手に使うことが肝要です。ここまで紹介してきた基本的なオブジェクト群は、`Foundation.framework` に内包されています。これは iOS でも OS X でも同じように使うことができます (残念ながら一部異なります)。フレームワークは `#import <Foundation/Foundation.h>` のようにインポートします。
>
> この `Foundation.framework` のほかに、iOS では `UIKit.framework`、OS X では `AppKit.framework` という、主に UI などと関係するフレームワークを使います。これらはプラットフォームに特化したもので互換性はありません。`Foundation` と `AppKit` または `UIKit` を合わせて、それぞれ `Cocoa` / `Cocoa touch` と呼んでいます。
>
> iOS / OS X には他にも様々なフレームワークがあり、これらをうまく活用することで、すばらしいアプリを簡単につくることさえ可能です。しかしまずはこの `Cocoa` を使いこなすことこそ、最高のアプリの最初の一歩となります。

　

> #### コラム - Toll Free Bridge
>
> `Foundation.framework` にはもう一つ秘密があります。`Foundation` に存在するいくつかのクラスは、`CoreFoundation.framework` という、C++ で実装された対応するクラスと相互に変換可能です。例えば `NSString` と `CFString` は相互に変換できます。しかもこのとき、変換のためのコストがかかりません。これを **Toll Free Bridge** と呼んでいます。
>
> なぜこのようなことになるかというと、`NSString` と `CFString` が実質的に同じものであるからです。このため、キャストするだけで変換することができます。
> ```objc
> NSString *string = @"string";
> CFStringRef cf_string = (__bridge CFStringRef)string;
> ```
> (`__bridge` というのはメモリ管理の上で必要となるアノテーションです。)
> またこの逆の変換も可能です。
>
> `CF` で始まる `CoreFoundation.framework` のクラスは、iOS や OS X の中でも C++ のインターフェースを持つフレームワークと共に使われます。また、`CFString` にしか存在しないメソッドなどもありますから、敢えて `CFString` として操作することが便利な場面もあります。

　

> [Foundation Framework Reference](https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/ObjC_classic/_index.html)
>
> [UIKit Framework Reference](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIKit_Framework/_index.html)

#### メッセージパッシング

見慣れない書き方ですが、ルールは簡単です。`[]` で囲います。`[オブジェクト メソッド]`。

```ojbc
NSObject *object1 = [NSObject new];
NSObject *object2 = [[NSObject alloc] init];
```

これが基本的な構文です。引数がある場合は `[オブジェクト メソッド:引数]` `[オブジェクト メソッド:ひとつめの引数 メソッド続き:ふたつめの引数]` となります。

```objc
NSObject *object3 = [[NSObject alloc] initWithAnother:object1 andYetAnother:object2];
```

このときのメソッド名は `initWithAnother:andYetAnother:` という風に、コロンを含んで繋げたものです。

ここでオブジェクトの同値性を確認します。

```objc
NSString *firstName = @"Steve";
NSString *fullName = [firstName stringByAppendingString:@" Ballmer"];
BOOL a = firstName == fullName; // => NO
BOOL b = fullName == @"Steve Ballmer"; // => Undefined behavior
BOOL c = [firstName isEqualToString:@"Steve Ballmer"]; // => NO
BOOL d = [fullName isEqualToString:@"Steve Ballmer"]; // => YES
```

`NSString` は変更できません。変更できるのは `NSMutableString` です。`==` はポインタ値の比較になります。オブジェクトの値の比較には `isEqual:` とか `isEqualToXXX:` を使いましょう。文字列リテラルのポインタ値の比較は内部実装に依存するため未定義です。ほとんどの場合で `isEqual:` を使います。

### クラス

Objective-C においてはクラスもオブジェクトです。`Class` オブジェクトは `class` というクラスメソッドや、`NSClassFromString` 関数で取り出します。

```objc
Class stringClass = [NSString class];
NSString *string = [[stringClass alloc] init];
if ([string isKindOfClass:[NSString class]]) {
    NSLog(@"%@", string);
}

Class arrayClass = NSClassFromString(@"NSArray");
```

`isKindOfClass:` メソッドで、オブジェクトがあるクラスかその子クラスであることを確かめることができます。

ここからはクラスの書き方を見ていきます。

#### クラスの定義

`Human.h`

```objc
#import <Foundation/Foundation.h> // Foundation.framework を読み込む

// 宣言部はじまり
@interface Human : NSObject; // NSObject を継承した Human クラス

@property (nonatomic, readonly) NSString *firstName; // 読み込み専用のプロパティ
@property (nonatomic, readonly) NSString *lastName; // 読み込み専用のプロパティ

+ (id)dummyHuman; // ダミーのインスタンスを作るためのクラスメソッド

- (id)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName; // 初期化するためのインスタンスメソッド

- (NSString *)fullName; // インスタンスメソッド

@end
// 宣言部終わり
```

#### クラスの実装

`Human.m`

```objc
#import 'Human.h' // ヘッダーファイルを読み込む

// 実装部はじまり
@implementation Human {
    NSString *_fullName; // インスタンス変数
}

+ (id)dummyHuman
{
    return [[self alloc] initWithFirstName:@"John" lastName:@"Doe"];
}

// 典型的なイニシャライザ
- (id)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName
{
    self = [super init];
    if (self) {
        _firstName = firstName;
        _lastName = lastName;
    }
    return self;
}

- (NSString *)fullName
{
    if (!_fullName) {
        _fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    }
    return _fullName;
}

@end
// 実装部終わり

```

Objective-C では宣言と実装が分かれています。ファイルを分けているのは便宜的ですが、ひとつのクラスには必ず `@interface` と `@implementation` のセットが必要です。

#### メソッド

```objc
// インスタンスメソッド
- (返り値の型)methodNameWithFirstArgument:(引数の型)引数の名前 secondArgument:(引数の型)引数の名前;
// クラスメソッド
+ (返り値の型)methodNameWithArgument:(引数の型)引数の名前;
```

引数の数だけ長くなっていきます。`methodNameWithFirstArgument:secondArgument:` という文字列全体がメソッドの名前です。

メソッドは `selector` という `SEL` 型の値で取り扱うことができます。

```obj
SEL selector = @selector(methodNameWithFirstArgument:secondArgument:);
UIButton *button = [[UIButton alloc] init];
[button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
```

`@selector(メソッドの名前)` という特別な書き方で selector を得ることができます。あるボタンが押されたときに呼び出されるメソッドを指定するときなどに、この selector が活用されます。

#### プロパティ

```objc
@property (nonatomic) NSString *firstName;
```

プロパティは自動的にアクセッサとなるインスタンスメソッドを作ります。

```objc
- (NSString *)firstName; // getter
- (void)setFirstName:(NSString *)newFirstName; // setter
```

プロパティの宣言はこのようなアクセッサを定義するのと同じで、自動的に生成されます。アクセッサと共にインスタンス変数も宣言され、`NSString *_firstName` のようにアンダースコアから始まります。

プロパティを定義することでドット構文が使えます（より正確には、ドット構文ではアクセッサが呼び出されるだけです。従ってアクセッサさえあればプロパティを定義する必要はありません）。

```objc
Human *man = [[Human alloc] init];
man.firstName = @"Junya";
NSLog(@"%@", man.firstName);
```

生成されるアクセッサは手で書いてもよいです。手で書くと、`setter` が呼ばれたときにフックするみたいなことができます。

プロパティにはいくつかの属性を指定できます。

- `atomic`, `nonatomic`
  - `atomic` は複数のスレッドから触るときに排他制御してくれる。デフォルト
  - `nonatomic` はそういうことしない代わりにパフォーマンスが良い
- `readwrite`, `readonly`
  - `readwrite` は読み書きできる。`getter` と `setter` が生成される。デフォルト
  - `readonly` は読み込み専用。`getter` しか生成されない
- `strong`, `weak`
  - `strong` は強参照。デフォルト
  - `weak` は弱参照

このほかにもありますが、代表的なものはこれくらいです。

#### 強参照と弱参照

ふたつのオブジェクトが互いに強参照で持ち合っているとき、これを循環参照と言います。循環参照の状態になるとメモリから解放されず、いわゆるメモリリークの状態になります。これを防ぐためには適切に弱参照に変える必要があります。

```objc
__strong NSString *firstName = @"Junya";
__weak NSString *lastName = @"Kondo";
```

オブジェクトは1つ以上の強い参照がなければすぐに解放されます。そのためこの状態では `lastName` はすぐに解放されます。解放されたあと `lastName` には自動的に `nil` が代入されます。

#### `self` と `super`

メソッド中に出てくる `self` は、オブジェクト自身を表すキーワードです。クラスメソッドならクラスオブジェクト、インスタンスメソッドならインスタンスオブジェクトを指しています。また `super` はスーパークラスを指すキーワードです。明示的にスーパークラスのメソッドを呼び出すときにはこれを使います。

> #### コラム - 動的 Objective-C
>
> Objective-C はコンパイルによってマシン語が生成される、コンパイラ言語の形を取っています。以前はコンパイラとして GCC の Apple によるフォークが使われていました (いまの GCC にも Objective-C をコンパイルする機能があります)。しかし現在では LLVM と Clang が使われるようになり、この新しいコンパイラによって近年 Objective-C は目覚ましい進化を遂げました。例えば ARC (Automatic Reference Count) と呼ばれる機能は、GC なしにプログラマをメモリ管理の煩わしさから解放することに成功しました。コンパイラがその静的解析機能によって事前に参照カウントを変更するコードを生成し、自動的に挿入してくれています。
>
> このようなコンパイラによって生成されたバイナリは、iOS や OS X のランタイム上で動作します。このため、Objective-C は完全なネイティブコードにコンパイルされるにもかかわらず、実際には動的なシステム上で動作します。言語機能としての実行時のクラス拡張などのほか、ランタイム関数を呼び出すことで親クラスを差し替えることすらできます。
>
> Cocoa は最大限にその動的特性の恩恵を受けたフレームワークと言えます。そのひとつは target-action パラダイムと呼ばれる仕組みです。例えばボタンが押されたときの動作を設定するために、`addTarget:action:forControlEvents:` というメソッドを用います。ボタンが押されたというイベント (定数) が起きたとき、ターゲット (オブジェクト) に対してアクション (メソッド) を呼び出す、ということを指定することができます。このアクションというのは、セレクタという `SEL` クラスのオブジェクトになっています。セレクタは `@selector(anyMethod:)` という構文でつくることができます。メソッドがセレクタオブジェクトで指定できることで、例えばターゲットオブジェクトがそのセレクタに応答するかを確認して、応答しないときボタンを `disable` にする、というような仕組みを簡単に作ることができます。
>
> 動的特性を多分に持つ Objective-C とそれを用いた Cocoa では、フレームワークレベルでそれが活かされています。もちろん動的であるが故の問題もありますが、しかしそれ以上に、その柔軟さが生み出すしなやかなプログラミングにはこころ惹かれるものがあります。

### blocks

Objective-C における関数オブジェクトです。block と呼びます。

```objc
NSString * (^capitalize)(NSString *) = ^NSString *(NSString *message) {
    return [message capitalizedString];
};
capitalize(@"smallcaps");
```

これが基本形です。

```objc
返り値の型 (^変数名)(引数の型) = ^返り値の型(引数の型) {処理};
```

このような構文になっています。返り値や引数の型となる `void` は省略可能です。具体的な使われ方として、非同期ネットワーク通信のコールバックとしての例を挙げます。

```objc
NSURL *URL = [NSURL URLWithString:@"http://www.hatena.ne.jp/"];
NSURLRequest *request = [NSURLRequest requestWithURL:URL];

[NSURLConnection sendAsynchronousRequest:request
                                   queue:[NSOperationQueue mainQueue]
                       completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                           if (error) {
                               NSLog(@"error = %@", error);
                           }
                           else {
                               NSLog(@"response = %@", response);
                               NSLog(@"data = %@", data);
                           }
                       }];
```

この `NSURLConnection` が提供する `sendAsynchronousRequest:queue:completionHandler:` メソッドでは、ネットワーク通信が終わったときに、予め渡しておいた block が実行されます。`NSURLConnection` にはもう一つ似たような `sendSynchronousRequest:returningResponse:error:` というメソッドがあります。

```objc
NSURL *URL = [NSURL URLWithString:@"http://www.hatena.ne.jp/"];
NSURLRequest *request = [NSURLRequest requestWithURL:URL];

NSHTTPURLResponse *response = nil;
NSError *error = nil;
NSData *data = [NSURLConnection sendSynchronousRequest:request
                                     returningResponse:&response
                                                 error:&error];
if (error) {
    NSLog(@"error = %@", error);
}
else {
    NSLog(@"response = %@", response);
    NSLog(@"data = %@", data);
}
```

このメソッドは同期的に実行されます。このためレスポンスが得られるまでの間スレッドがブロックします。メインスレッドがブロックされると UI の動作も止まってしまうため、適宜他のスレッドで実行するべきです。

blocks はこのような非同期処理を行いたい場面でも使われますが、そのほかにも、OS X/iOS の世界では多くの場面で blocks を引数に取るメソッドが用意されています。その一例として `NSArray` を挙げます。

```objc
NSArray *array = @[@"a", @"b", @"c"];
[array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSLog(@"%@", obj);
}];
```

これは `NSArray` の `enumerateObjectsUsingBlock:` メソッドで、引数の block が配列の各要素について実行されます。次は同じことを別な書き方で表します。

```objc
NSArray *array = @[@"a", @"b", @"c"];
for (id obj in array) {
    NSLog(@"%@", obj);
}
```

余談ですが、Objective-C には `for...in` 構文があり、`NSArray` なら各要素を、`NSDictionary` なら各キーを順に得ることができます。

> #### コラム - `NSFastEnumeration` Protocol
>
> `for...in` 構文は、`NSFastEnumeration` Protocol で実現されます。このプロトコルに準拠したクラスのオブジェクトは、`for...in` による高速列挙が行えます。
>
> 興味深いことに、`NSEnumerator` クラスというものが存在し、`NSFastEnumeration` プロトコルに準拠しています。`NSArray` の `objectEnumerator` や `reverseObjectEnumerator` メソッドを呼ぶと、この `NSEnumerator` オブジェクトが返ります。これを `for...in` することもできるので、`reverseObjectEnumerator` で返ってくる `NSEnumerator` を使えば、逆順に `for...in` できることになります。
>
> ```objc
> NSArray *array = @[@"a", @"b", @"c"];
> for (id obj in [array reverseEnumerator]) {
>     NSLog(@"%@", obj);
> }
```

---

## アーキテクチャ

ここからは Intern::Bookmark アプリを作るという前提で、どのようなクラス構成にしていくかを考えていきます。ステートレスな Web アプリケーションとは異なる部分も多いですが、似ている部分も少なくありません。

Web アプリケーションと同様に、スマートフォンアプリにおいても MVC の構造は一緒です。始めに以下の図を見てください。(適切な図ではないけど諦めた)

![アーキテクチャ](https://www.evernote.com/shard/s2/sh/97059c39-92fd-4c41-902e-430bbc68aff4/e2d5c0d9933f544419676a4b11a5bc5c/deep/0/intern-bookmark-architecture.png)

ここで、`ViewController` となっているものが `Controller` にあたり、残りは `Model` です。`View` はここには書いていませんが、iOS 開発においてはそれぞれの `ViewController` が `View` を持っています。ビューのレイアウトは、NIB/XIB という XML ファイルが用いられてきましたが、最近の iOS 開発においては Storyboard という仕組みを使います。Storyboad はビューのレイアウトだけでなく、画面と画面の関係性まで記述することができる仕組みですが、これについては後で使い方を説明します。

### モデル

モデルは主としてビジネスロジックを担当する部分です。またデータを抽象化したデータモデルとしての役割も持ちます。この例でいうと、`Bookmark`, `Entry`, `User` はデータモデル、`BookmarkManager` と `BookmarkAPIClient` はビジネスロジックを担当しています。

`BookmarkManager` は、`Bookmark` オブジェクトを管理するシングルトンオブジェクトです。ブックマーク一覧を取得したり、新しくブックマークするときはこれを介して操作します。

`BookmarkAPIClient` は、Intern::Bookmark の API とのネットワーク通信を抽象化します。リクエストを送信して、レスポンスの JSON を `NSDictionary` にして返すところまでの責任を負います。

実質的に、`BookmarkManager` だけが `BookmarkAPIClient` を操作することになります。

データモデルは、JSON をパースして得られた `NSDictionary` から初期化できると便利でしょう。このとき、注意深く値をバリデーションすべきです。

### コントローラー

iOS の場合、おおよそ画面ひとつに対してひとつの `ViewController` を用意することになります（例外もあります）。`ViewController` は名前の通り `View` と密接に結びつき、ビューを必要に応じて更新し、またビューに対するユーザーの操作をモデルに伝える役割を持ちます。

今回の場合は、ブックマーク一覧画面と、個別ブックマーク画面のふたつを作るので、それぞれに対応する `BookmarksViewController` と `BookmarkViewController` (単数形と複数形の違いに注意してください) を作ります。

`BookmarksViewController` は、ブックマーク一覧を表示し、必要に応じて再読込し、そしてユーザーによって選択されたブックマークを開く機能を持ちます。

`BookmarkViewController` は個々のブックマークの内容を表示すると共に、今回は新しくブックマークする機能もここに用意します。

このような設計で作ったものを [Intern::Bookmark アプリ](https://github.com/hatena/ios-Intern-Bookmark-Simple-2014) として用意してあります。参考にしてください。
またSwift版の[Intern::Bookmark アプリ](https://github.com/hatena/ios-Intern-Bookmark-Simple-Swift-2014) も用意しましたので、興味がある方はお試しください。

## チュートリアル『Intern::Bookmark』アプリを作ろう

ここからは Intern::Bookmark アプリを、ブックマーク一覧を表示できるようにするところまで、実際に作っていく手順を見ていきます。

### プロジェクト作成

Xcode を開いて新しいプロジェクトを作ります。

![Master-Detail Application を選びましょう](https://www.evernote.com/shard/s2/sh/30dd924f-c05f-4d2f-b378-d7836ee8932f/2eac8fce0ec235df17bf13fe787c1086/deep/0/xcode-master-detail-application.png)

Master-Detail Application を選んで Next。

![プロジェクトの設定](https://www.evernote.com/shard/s2/sh/de7b2fbb-52d6-4466-b489-caf6f32a00ea/bc5bd878e031cd268e19c541481993c8/deep/0/xcode-choose-options.png)

`Use Storyboard` と `Use Automatic Reference Counting` に必ずチェックを付けましょう。

適当なところに保存すると、プロジェクトができあがります。

![画面の説明](https://www.evernote.com/shard/s2/sh/111b87e4-ccf6-405b-ac8f-c6b50d34ceaf/b2aa5ca939d5cc4b18563becfd0087c9/deep/0/Intern%20Bookmark.xcodeproj.png)

ここで `.gitignore` を適切に設定しましょう。[GitHub の `.gitignore`](https://github.com/github/gitignore/blob/master/Objective-C.gitignore) がおすすめです。

### CocoaPods で依存ライブラリ管理

最近の OS X/iOS では、外部のモジュールを利用するときに [CocoaPods](http://cocoapods.org/) というのを使って管理します。CPAN や RubyGems と似ています。始めに CocoaPods をインストールします。Terminal を開いて

```
$ [sudo] gem install cocoapods
$ pod setup
```

としてください（CocoaPods 自体が gem として作られています）。システムの Ruby を使っているときなどは必要に応じて `sudo` してください。`pod` コマンドが追加され、CocoaPods の機能が使えるようになります。

次に Intern::Bookmark アプリのプロジェクトのディレクトリを開き、`Podfile` という名前のファイルを作成します。

```ruby
platform :ios, '7.0'

pod 'AFNetworking', '~> 2.0'
```

ファイルの内容はこのようにします。ここでは `AFNetworking` という、ネットワーク通信を簡単にするためのライブラリを使います。ファイルを保存したらそのディレクトリで `pod install` してください。以下のようになるはずです。

```
$ pod install
# Analyzing dependencies
# Downloading dependencies
# Installing AFNetworking 2.3.1
# Generating Pods project
# Integrating client project
#
# [!] From now on use `Intern Bookmark.xcworkspace`.
```

ここで一度 Xcode のプロジェクトを閉じて、プロジェクトのディレクトリの `.xcworkspace` という拡張子のファイルを開いてください。開くと左のサイドバーに、Intern Bookmark だけでなく Pods というプロジェクトが表示されるようになったはずです。こうすることで、アプリをビルドするときに CocoaPods 管理下のライブラリを一緒にビルドできるようになります。先ほどまでの `.xcodeproj` に代わって、今後はこれを使っていきます。

### ビルド

この段階で一度ビルドしてみましょう。Xcode 左上の `Run` を押します。このとき少し右の `Scheme` というところで、正しいスキームとターゲットデバイスが設定されていることを確認します。スキームというのはビルドする設定のことで、必要に応じて切り替えることができますが、いまはプロジェクト名のスキームを使います。ターゲットデバイスはとりあえず `iPhone Retinal (4-inch)` を選びます。

![iPhone Simulator](https://www.evernote.com/shard/s2/sh/6274a688-7c9d-4ccd-a752-34a8c775f023/e9e4013657342f049f3740469c4d7cab/deep/0/iphone-simulator.png)

この段階でうまくビルドできないことはないはずです。止めるときは Xcode 左上の `Stop` を押します。

今後はこのビルドを何度も行い、少しずつアプリを作っていきます。必要なタイミングになったら iOS 端末を接続し、ターゲットデバイスを実際の端末にします。

### `ViewController` 作成と Storyboard

Storyboard にははじめからふたつのビューコントローラーが置かれています。このビューコントローラーを自分で作成したクラスと置き換えていきます。最初からあるふたつのビューコントローラーのクラスを削除し、新しく `UITableViewController` を継承した `IBKMBookmarksViewController` と `UIViewController` を継承した `IBKMBookmarkViewController` を作ります。Storyboard 編集画面から、並んでいるビューコントローラーのクラスを自分で作ったものに置き換えます。

#### [操作している様子の動画](https://dl.dropboxusercontent.com/u/441261/intern-bookmark-1.mp4)

![Storyboard](https://www.evernote.com/shard/s2/sh/d34bd697-beb5-4b1d-ad01-243b103cdca0/286659fc8fcaf6806db75f7bf859ea74/deep/0/storyboard.png)

`UINavigationController` は画面上部の `UINavigationBar` によって、階層のある画面の関係を管理します。最初に表示される `rootViewController` が `BookmarksViewController` になっているので、最初にブックマーク一覧画面が表示されます。`BookmarksViewController` は `UITableViewController` のサブクラスで、`UITableView` というリスト形式のビューをうまく管理します。いまひとつだけプロトタイプとなる `UITableViewCell` が用意されています。このセルを選択したときの動作を、`UIStoryboardSegue` という画面遷移を表したオブジェクトで表現しています。遷移の種類が `push` となることで、`UINavigationController` の階層をひとつ潜るような画面遷移が自動的に行われます。遷移先は `BookmarkViewController` で、これはブックマークの詳細を表示するために用意しています。

### API と ネットワーク通信

始めに、ブックマーク一覧を取得する API のエンドポイントを `/api/bookmarks` として、得られる JSON 形式のコンテンツを

```json
{
   "bookmarks" : [
      {
         "created" : "2013-07-18 05:41:34",
         "entry" : {
            "created" : "2013-07-18 05:41:34",
            "url" : "http://space.hatena.ne.jp/",
            "updated" : "2013-07-18 05:41:34",
            "title" : "はてなスペース",
            "entry_id" : 28
         },
         "comment" : "space!",
         "bookmark_id" : 28,
         "user" : {
            "created" : "2013-07-16 01:43:51",
            "name" : "cockscomb",
            "user_id" : 1
         },
         "updated" : "2013-07-18 05:43:06"
      },
      ...
   ]
}
```

ということにします。この API を叩いてブックマークを取得する部分を作ります。

ネットワーク通信は、`NSURLRequest` を `NSURLConnection` を介して送信して、レスポンスを得る、というのが Foundation.framework が提供するやり方です。しかし `NSURLRequest` を組み立てたり、ネットワーク通信を細かく制御したり、レスポンスとして得たバイナリの `NSData` から JSON を取り出しパースするところまでは自分で面倒を見ないといけません。

ここでは AFNetworking という非常によく使われているサードパーティーのライブラリを使って、このネットワーク通信部分をさらに抽象化し、簡単に行います。

はじめに `AFHTTPSessionManager` を管理する`IBKMInternBookmarkAPIClient` を作ります。このシングルトンオブジェクトが API との通信全てを仲介します。

```objc
#import "AFHTTPSessionManager.h"

@interface IBKMInternBookmarkAPIClient : NSObject

+ (instancetype)sharedClient;

- (void)getBookmarksWithCompletion:(void (^)(NSDictionary *results, NSError *error))block;

@end

```

```objc
#import "IBKMInternBookmarkAPIClient.h"

static NSString * const kIBKMInternBookmarkAPIBaseURLString = @"http://localhost:3000/";

@interface IBKMInternBookmarkAPIClient()

@property (nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation IBKMInternBookmarkAPIClient

+ (instancetype)sharedClient
{
    static IBKMInternBookmarkAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] init];
    });

    return _sharedClient;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPAdditionalHeaders = @{
            @"Accept" : @"application/json",
        };

        self.sessionManager = [[AFHTTPSessionManager alloc]
                         initWithBaseURL:[NSURL URLWithString:kIBKMInternBookmarkAPIBaseURLString]
                         sessionConfiguration:configuration];
    }

    return self;
}

- (void)getBookmarksWithCompletion:(void (^)(NSDictionary *results, NSError *error))block
{
    [self.sessionManager GET:@"/api/bookmarks"
       parameters:@{}
          success:^(NSURLSessionDataTask *task, id responseObject) {
              if (block) block(responseObject, nil);
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              if (block) block(nil, error);
          }];
}

@end
```

`sharedClient:` クラスメソッドが、シングルトンの `IBKMInternBookmarkAPIClient` オブジェクトを得るためのメソッドです。これは典型的なシングルトンの実装になっています。`AFHTTPSessionManager` はレスポンスのボディを JSON として扱い、自動的にパースして `NSDictionary` にしてくれます。パース自体は Foundation.framework の `NSJSONSerialization` が行います。

`getBookmarksWithCompletion:` メソッドは、`AFHTTPSessionManager` の `GET:parameters:success:failure:` メソッドを使って実際に通信を行い、レスポンスをコールバック用の block に渡します。`parameters` に `NSDictionary` を与えてパラメーターを付加することもできます。このメソッドを呼ぶだけで簡単に JSON をパースした辞書を得ることができ、またエラーが起きたときにもハンドリングしやすくなります。

これを用いる `IBKMBookmarkManager` を実装します。このオブジェクトもシングルトンにしておきます。

```objc
#import <Foundation/Foundation.h>

@class IBKMBookmark;

@interface IBKMBookmarkManager : NSObject

@property (nonatomic, readonly) NSArray *bookmarks;

+ (IBKMBookmarkManager *)sharedManager;

- (void)reloadBookmarksWithBlock:(void (^)(NSError *error))block;

@end
```

```objc
#import "IBKMBookmarkManager.h"

#import "IBKMInternBookmarkAPIClient.h"
#import "IBKMBookmark.h"

@interface IBKMBookmarkManager ()

@property (nonatomic) NSArray *bookmarks;

@end

@implementation IBKMBookmarkManager

+ (IBKMBookmarkManager *)sharedManager
{
    static IBKMBookmarkManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });

    return _sharedManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.bookmarks = @[];
    }

    return self;
}

- (void)reloadBookmarksWithBlock:(void (^)(NSError *error))block
{
    [[IBKMInternBookmarkAPIClient sharedClient]
         getBookmarksWithCompletion:^(NSDictionary *results, NSError *error) {
             if (results) {
                 NSArray *bookmarksJSON = results[@"bookmarks"];
                 self.bookmarks = [self parseBookmarks:bookmarksJSON];
             }
             if (block) block(error);
         }
     ];
}

- (NSArray *)parseBookmarks:(NSArray *)bookmarks
{
    NSMutableArray *mutableBookmarks = [NSMutableArray array];

    [bookmarks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        IBKMBookmark *bookmark = [[IBKMBookmark alloc] initWithJSONDictionary:obj];
        [mutableBookmarks addObject:bookmark];
    }];

    return [mutableBookmarks copy];
}

@end
```

モデルクラスとなる `IBKMBookmark`, `IBKMEntry`, `IBKMUser` も予め作っておきます。こうしておいて

```objc
[[IBKMBookmarkManager sharedManager] reloadBookmarksWithBlock:^(NSError *error) {
    NSLog(@"%@", [IBKMBookmarkManager sharedManager].bookmarks);
}];
```

というのをどこかに書いてアプリを起動すると、ログにブックマークが得られている様子が表示されます。

```
2013-07-25 16:46:10.688 Intern Bookmark[94903:c07] (
    "<IBKMBookmark: self.bookmarkID=28, self.comment=space!, self.entry=<IBKMEntry: self.entryID=28, self.URL=http://space.hatena.ne.jp/, self.title=\U306f\U3066\U306a\U30b9\U30da\U30fc\U30b9, self.created=2013-07-18 05:41:34 +0000, self.updated=2013-07-18 05:41:34 +0000>, self.user=<IBKMUser: self.userID=1, self.name=cockscomb, self.created=2013-07-16 01:43:51 +0000>, self.created=2013-07-18 05:41:34 +0000, self.updated=2013-07-18 05:43:06 +0000>",
…
)
```

より詳細は [AFNetworking のドキュメント](http://cocoadocs.org/docsets/AFNetworking/2.0.0/) やサンプルアプリを参照してください。

### `UITableView`

`UITableView` への表示は、`UITableViewDelegate` と `UITableViewDataSource` のふたつのデリゲートを実装することで行います。これらデリゲートのメソッドは非常にたくさんありますが、その中でも最低限 `tableView:numberOfRowsInSection:` と `tableView:cellForRowAtIndexPath:` のふたつを実装することで、ブックマーク一覧を実現できます。

`IBKMBookmarksViewController` にこのふたつのメソッドを実装します。

```objc
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[IBKMBookmarkManager sharedManager].bookmarks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"IBKMBookmarkCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    IBKMBookmark *bookmark = [IBKMBookmarkManager sharedManager].bookmarks[indexPath.row];

    cell.textLabel.text = bookmark.entry.title;
    cell.detailTextLabel.text = [bookmark.entry.URL absoluteString];

    return cell;
}
```

`tableView:numberOfRowsInSection:` は、表示したいセルの個数を返すメソッドです。ここではブックマークの個数をそのまま返しています。`tableView:cellForRowAtIndexPath:` は、表示されるセルを直接返すメソッドです。はじめに `UITableView` の `dequeueReusableCellWithIdentifier:forIndexPath:` を使って、Table View からセルの原型を取得します。この ID のセルは、Storyboard で予め定義しておいたものを使うことができます。次に、セルのラベルに表示したいテキストを設定します。こうしてセルを返すと、セルそれぞれに個別の内容が設定されます。

ここで、予めブックマーク一覧を読み込んでおく必要があります。ブックマーク一覧を読み込んで、Table View を更新するためには

```objc
[[IBKMBookmarkManager sharedManager] reloadBookmarksWithBlock:^(NSError *error) {
    if (error) {
        NSLog(@"Error: %@", error);
    }
    [self.tableView reloadData];
}];
```

という風にします。この block は API からブックマーク一覧を更新したときに実行されるので、このタイミングで Table View のデータをリロードすることで、ブックマーク一覧を表示できます。

ところでこのコードはどこに置くのがよいでしょうか。ビューコントローラーのライフサイクルを考える必要があります。ライフサイクルの詳細は脚注に示しますが、実際これは非常に複雑です。しかし基本的なルールはカンタンです。主に使われるのは以下の6つです。

- `viewDidLoad:`
- `viewWillAppear:`
- `viewDidAppear:`
- `viewWillDisappear:`
- `viewDidDisappear:`
- `viewDidUnload:`

そして View の初期化処理は `viewDidLoad:` の時点でほとんど行ってしまいます。ですから先ほどの処理は

```objc
- (void)viewDidLoad
{
    [super viewDidLoad];

    [[IBKMBookmarkManager sharedManager] reloadBookmarksWithBlock:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
        [self.tableView reloadData];
    }];
}
```

このようになります。ここまででブックマーク一覧は表示されるようになったはずです。

### 画面遷移

セルを選択したときの画面遷移を作ります。画面遷移は Storyboard で定義されており、それには ID が付けてあります。画面遷移自体は Storyboard に従って勝手に行われますが、値の受け渡しはきちんと実装しなければなりません。画面遷移する前に `prepareForSegue:sender:` というメソッドが呼ばれるので、これをオーバーライドします。

```objc
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"IBKMOpenBookmarkSegue"]) {
        NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
        IBKMBookmark *bookmark = [IBKMBookmarkManager sharedManager].bookmarks[selected.row];

        IBKMBookmarkViewController *bookmarkViewController = segue.destinationViewController;
        bookmarkViewController.bookmark = bookmark;
    }
}
```

`segue` 仮引数に画面遷移を表す `UIStoryboardSegue` が渡ってくるので、この `identifier` を確認して、必要な処理を挟みます。表示される新しい View Controller は `segue.destinationViewController` で得られるので、これに選択された `IBKMBookmark` オブジェクトを渡します。あとは、`IBKMBookmarkViewController` がその責任で次の画面を作ります。

`BookmarkViewController` 画面に、テキストを表示する `UILabel` を3つ用意しておいて、`viewDidLoad:` でそれぞれの内容を設定します。

```objc
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = self.bookmark.entry.title;
    self.titleLabel.text = self.bookmark.entry.title;
    self.URLLabel.text = [self.bookmark.entry.URL absoluteString];
    self.commentLabel.text = self.bookmark.comment;
}
```

ついでに `self.title = self.bookmark.entry.title` として、Navigation Bar のタイトルも設定しました。

Navigation Controller で前の画面に戻るのは、Navigation Controller が勝手に行ってくれるので、これだけで必要な実装は終わりです。

Storyboard の設定などはこの説明から省略しています。ここまでの流れを以下の動画で順を追って確認していきます。

[実際の操作ビデオ](https://dl.dropboxusercontent.com/u/441261/intern-bookmark-2.mp4)

---

## 課題

課題では、これまで作ってきた `Intern::Diary` の iPhone アプリを作ってもらいます。JavaScript の課題で作っているはずの JSON API をなるべく使い回して構いません。一からアプリを作成し、できれば実機で動作させましょう。

### 課題

iPhone アプリで記事一覧を表示できるようにしてください。表示には `UITableView` を使ってみましょう。また個別の記事を選択したとき、個別記事画面に遷移するようにしてください。

### オプション課題

iPhone アプリから記事を投稿できるようにしましょう。必要に応じて API も作成してください。

### 自由課題

創意工夫をしてよりよいアプリにしてください。

- 記事一覧がページングするように
  - API から一度に取得する記事が多いと、特にスマートフォンのネットワーク環境では問題になりがち
  - 一度に20件くらいずつ取得し、それを `UITableView` でうまく継ぎ足すようにする
- 既存の記事を編集できるようにする
  - 開いた記事をそのまま編集し、サーバーに反映させる
- より使いやすい UI にする
- おもしろい機能を追加する
- など

## 課題に取り組む前に

* [hatena/ios-Intern-Diary-2014](https://github.com/hatena/ios-Intern-Diary-2014) を fork する
* 空の Pull Request を作る
  * これまでの講義と同様にこの Pull Request で課題を提出する

---

## おまけ

### Objective-C 追補

#### プロトコル

あるクラスが一連のメソッドに応答することを約束するために、プロトコルというのがあります。

```objc
@protocol Flyable

- (void)up;
- (void)down;

@optional

- (void)rotate;

@end
```

プロトコルの宣言は上記のように行います。この `Flyable` プロトコルは、上昇、下降ができることを約束させ、またオプションですが、旋回できるかもしれないことを表します。このプロトコルに準拠するには少なくとも `up` と `down` メソッドを実装する必要があります。プロトコルに準拠したことを表明するときはヘッダーファイルに書き加えます。

```objc
@interface Helicopter : NSObject <Flyable>

..

@end
```

`<>` の中にカンマ区切りで対応するプロトコルの名前を記載します。

プロトコルの利用例として delegate があります。iOS でブラウザ画面を提供する `UIWebView` は `UIWebViewDelegate` というプロトコルを持ち、これに対応するオブジェクトを delegate に登録しておくことで、WebView の状態が変わったときそれを知ることができます。

```objc
@interface MyClass : NSObject <UIWebViewDelegate>
```

このように宣言し

```ojbc
MyClass *obj = [[MyClass alloc] init];
UIWebView *webView = [[UIWebView alloc] init];
webView.delegate = obj;
```

のように `delegate` プロパティに設定します。`delegate` プロパティは `weak` になっていることが多いので、気をつける必要があります。

```
– webView:shouldStartLoadWithRequest:navigationType:
– webViewDidStartLoad:
– webViewDidFinishLoad:
– webView:didFailLoadWithError:
```

あとは `MyClass` が上記のメソッドを実装することで、`UIWebView` の状態が変化したときそれを知り、必要に応じて何らかの処理を行うことができます。

#### カテゴリ

既にあるクラスに、新しくメソッドを増やしたいとき、カテゴリという機能を使うことができます。

```objc
#import <Foundation/Foundation.h>

@interface NSDateFormatter (MySQL)

+ (instancetype)MySQLDateFormatter;

@end
```

```objc
#import "NSDateFormatter+MySQL.h"

@implementation NSDateFormatter (MySQL)

+ (instancetype)MySQLDateFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    formatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return formatter;
}

@end
```

これらのヘッダーと実装ファイルをそれぞれ `NSDateFormatter+MySQL.h` `NSDateFormatter+MySQL.m` とすると、`[NSDateFormatter MySQLDateFormatter];` として呼び出すことができます。`(MySQL)` というのがカテゴリの名前になります。`NSDateFormatter` は日付を表す `NSDate` と `NSString` を相互にやり取りするときに用いる標準的なクラスですが、こういう風に拡張することができます。

これは既にあるクラスの拡張に便利なほか、外部から隠したいインターフェースを実現するときにも用いられます。

```objc
#import "Human.h"

@interface Human ()

@property (nonatomic) NSNumber *weight;

@end

@implementation Human
..
```

このように実装ファイルで無名のカテゴリを宣言することで、ヘッダーには載せずに `@interface` の一部を宣言できます。外から知られたくないプロパティを作るときなどに利用されています。

### イディオム

ここからは使うことになりそうな、いくつかの典型的なイディオムを紹介します。

#### 通知

すでに紹介した、デリゲートや block を引数に取るようなパターンで、たいていのコールバックはうまく働きます。しかし、これでは1対1の対応になり、また参照が得られないと機能しません。1対多や、参照を得にくい遠くのオブジェクトから何かのイベントを受け取りたいとき、どうすればよいのでしょう。

##### `NSNotificationCenter`

[`NSNotificationCenter`](https://developer.apple.com/library/ios/#documentation/Cocoa/Reference/Foundation/Classes/NSNotificationCenter_Class/Reference/Reference.html) の活用はそのひとつの答えです。`NSNotificationCenter` を介して通知をやり取りすることで、1対多で、オブジェクト間の距離を気にせずイベントの受け渡しができます。

```objc
[[NSNotificationCenter defaultCenter] postNotificationName:@"MyNotification" object:self userInfo:@{}];
```

通知の送信は `postNotificationName:object:userInfo:` メソッドを呼ぶです。`name` がキーとなって通知をやり取りしますから、重複しないようにするべきです。`userInfo` には任意の情報を格納できます。

```objc
- (void)initializeMethod
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:@"MyNotification" object:nil];
}

- (void)notificationHandler:(NSNotification *)notification
{
    // 何らかの処理
    NSLog(@"%@", notification.userInfo);
}
```

受け取るときは、上記のように `addObserver:selector:name:object:` メソッドで、自分を通知の監視者として登録します。この `@selector(notificationHandler:)` という書き方で、メソッドの `selector` を指定することで、通知を受けたときにこのメソッドが呼ばれるようになります。

不要になったら`removeObserver:`メソッドを呼び出して必ず通知を解除するようにしましょう。

この仕組みは様々な場面で活用されています。

##### KVO ([Key Value Observation](https://developer.apple.com/library/ios/#documentation/Cocoa/Reference/Foundation/Protocols/NSKeyValueObserving_Protocol/Reference/Reference.html))

他のオブジェクトのプロパティの値を監視したいとき、KVO という仕組みを使うことができます。

```objc
Human *human = [[Human alloc] init];
[human addObserver:self forKeyPath:@"lastName" options:NSKeyValueObservingOptionNew context:nil];
```

このようにすることで、他のオブジェクトのプロパティを監視します。`keyPath` というのは、KVC (Key Value Coding) からくる概念で、`keyPath` に指定された文字列から一定のルールで呼び出されるメソッドが決定されます。今回のような場合では特に意識しなくてもアクセッサが呼ばれるので、ここで詳しくは説明しません。必要に応じてドキュメントを参照してください。

```objc
[[self mutableArrayValueForKey:@"bookmarks"]
        insertObjects:newBookmarks atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newBookmarks.count)]];
```

このように `mutableArrayValueForKey:` を使うことで、`NSMutableArray` 型のプロパティの内容の変更についても通知を発火させることができます。

[日本語ドキュメント](https://developer.apple.com/jp/devcenter/ios/library/japanese.html)の『キー値監視プログラミングガイド』が詳細に解説しています。

```objc
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"lastName"] && object == human) {
        // ここで処理
    }
}
```

変更を受け取りたい側はこのように `observeValueForKayPath:ofObject:change:context:` メソッドを実装します。詳細はドキュメントを参照してください。

不要になったら`removeObserver:forKeyPath:`メソッドを呼び出して必ず通知を解除するようにしましょう。

KVO を効果的に利用することで、モデルの変更をビュー、またはコントローラーが一方的に監視することが可能になります。これによってモデルと他のオブジェクトの結合を弱くでき、モデルが自分の仕事に集中できます。

### View Controller のライフサイクル

[View Controller Programming Guide for iOS](https://developer.apple.com/library/ios/#featuredarticles/ViewControllerPGforiPhoneOS/Introduction/Introduction.html) 参照してください。

- [Resource Management in View Controllers](https://developer.apple.com/library/ios/#featuredarticles/ViewControllerPGforiPhoneOS/ViewLoadingandUnloading/ViewLoadingandUnloading.html)
- [Responding to Display-Related Notifications](https://developer.apple.com/library/ios/#featuredarticles/ViewControllerPGforiPhoneOS/RespondingtoDisplay-Notifications/RespondingtoDisplay-Notifications.html)

この辺りです。[日本語ドキュメント](https://developer.apple.com/jp/devcenter/ios/library/japanese.html)では「iOS View Controller プログラミングガイド」です。

### デバッグ

iOS/OS X プログラミングにおけるデバッグの手法をいくつか紹介します。

#### `NSLog`

ログを出します。

```objc
NSDictionary *dict = @{ @"a" : @"b" };
NSLog(@"Dictionary: %@", dict);
```

出力は、対象のオブジェクトの `description` メソッドが使われます。必要に応じてこれを実装しておくとよいでしょう。

#### デバッガと breakpoint

ブレークポイントを設定することで、実行中のプログラムを特定の位置で止めることができます。Xcode から GUI でブレークポイントを操作できます。Safari や Chrome の Web インスペクタともよく似ています。

![ブレークポイントで止めているときの Xcode](https://www.evernote.com/shard/s2/sh/ec7da491-71e8-4caf-9ff3-e61debd6e572/10164606e9076f8ab9833d2eae4bbf84/deep/0/breakpoints.png)

例外発生時にブレークポイントを設定することができ、これをしておくことでエラーに対処しやすくなります。

#### 静的解析

Clang の Static Analyzer を使えば、プログラムを実行する前に潜在的なエラーを探すことができます。Xcode のメニューから `[Run] -> [Analyze]` を実行すると、静的解析が行われ、問題が起こり得る場所を指摘してくれます。

#### Instruments

Xcode に付属する Instruments を使うと、さらに高度な解析が簡単に行えます。メモリリークの発見や、`deallocate` されたオブジェクトへの操作によるエラー、パフォーマンスのチューニングなど、多くのことができます。詳しくはドキュメントを参照してください。

- [Instruments User Guide](https://developer.apple.com/library/ios/#documentation/DeveloperTools/Conceptual/InstrumentsUserGuide/Introduction/Introduction.html)
- [日本語ドキュメント](https://developer.apple.com/jp/devcenter/ios/library/japanese.html)の「Instruments ユーザガイド」

### 参考資料

#### ドキュメント

- Xcode から読めるドキュメント
- [Apple Developer Center](http://developer.apple.com/ios/)
  - 公式ドキュメント
- [日本語ドキュメント](https://developer.apple.com/jp/devcenter/ios/library/japanese.html)
  - 公式ドキュメントの公式日本語訳。わりと更新されていて英語よりやや読みやすいかもしれない。開発ガイド的なものだけある
- [iOS Development Training Course](https://github.com/mixi-inc/iOSTraining)
  - 株式会社 mixi のトレーニングコース。とても充実しています。

#### 書籍

- [絶対に挫折しない iPhoneアプリ開発「超」入門【iOS7対応】増補改訂版](http://www.amazon.co.jp/%E7%B5%B6%E5%AF%BE%E3%81%AB%E6%8C%AB%E6%8A%98%E3%81%97%E3%81%AA%E3%81%84-iPhone%E3%82%A2%E3%83%97%E3%83%AA%E9%96%8B%E7%99%BA%E3%80%8C%E8%B6%85%E3%80%8D%E5%85%A5%E9%96%80%E3%80%90iOS7%E5%AF%BE%E5%BF%9C%E3%80%91%E5%A2%97%E8%A3%9C%E6%94%B9%E8%A8%82%E7%89%88-%E9%AB%98%E6%A9%8B-%E4%BA%AC%E4%BB%8B/dp/4797375450/ref=dp_ob_title_bk)
  - iOS アプリ開発の入門書です。チュートリアル形式でいろいろ書いてあるので取っつきやすいと思います
- [詳解 Objective-C 2.0 第3版](http://www.amazon.co.jp/%E8%A9%B3%E8%A7%A3-Objective-C-2-0-%E7%AC%AC3%E7%89%88-%E8%8D%BB%E5%8E%9F/dp/4797368276)
  - Objective-C の言語について知りたかったらこれがいちばんよいと思います

ここからはより iOS / OS X の開発に親しみたい人向けです

- [Dynamic Objective-C](http://www.amazon.co.jp/Dynamic-Objective-C-%E6%9C%A8%E4%B8%8B-%E8%AA%A0/dp/4861006414)
  - Objective-C の動的特性や、Cocoa におけるデザインパターンについて書かれています
  - 書籍はすでに絶版ですが、[元となった Web での連載](http://news.mynavi.jp/column/objc/index.html)がいまも公開されています
- [iOS開発におけるパターンによるオートマティズム](http://www.amazon.co.jp/iOS%E9%96%8B%E7%99%BA%E3%81%AB%E3%81%8A%E3%81%91%E3%82%8B%E3%83%91%E3%82%BF%E3%83%BC%E3%83%B3%E3%81%AB%E3%82%88%E3%82%8B%E3%82%AA%E3%83%BC%E3%83%88%E3%83%9E%E3%83%86%E3%82%A3%E3%82%BA%E3%83%A0-%E6%9C%A8%E4%B8%8B-%E8%AA%A0/dp/4861007348/)
  - iOS アプリ開発の定石が紹介されています。著者は『Dynamic Objective-C』と同じ木下誠氏で、木下氏は長年この分野に取り組んでいらっしゃいます
- [スマートフォンのためのUIデザイン ユーザー体験に大切なルールとパターン](http://www.amazon.co.jp/%E3%82%B9%E3%83%9E%E3%83%BC%E3%83%88%E3%83%95%E3%82%A9%E3%83%B3%E3%81%AE%E3%81%9F%E3%82%81%E3%81%AEUI%E3%83%87%E3%82%B6%E3%82%A4%E3%83%B3-%E3%83%A6%E3%83%BC%E3%82%B6%E3%83%BC%E4%BD%93%E9%A8%93%E3%81%AB%E5%A4%A7%E5%88%87%E3%81%AA%E3%83%AB%E3%83%BC%E3%83%AB%E3%81%A8%E3%83%91%E3%82%BF%E3%83%BC%E3%83%B3-%E6%B1%A0%E7%94%B0-%E6%8B%93%E5%8F%B8/dp/4797372303/)
  - UI デザインをパターンとして分類し、紹介されています。UI に迷ったり、使いやすいアプリを作るときには、このような書籍を参考にするのがよいでしょう




<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/2.1/jp/"><img alt="クリエイティブ・コモンズ・ライセンス" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/2.1/jp/88x31.png" /></a><br />この 作品 は <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/2.1/jp/">クリエイティブ・コモンズ 表示 - 非営利 - 継承 2.1 日本 ライセンスの下に提供されています。</a>