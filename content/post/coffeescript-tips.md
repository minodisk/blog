---
layout: post
title: "CoffeeScript Tips"
date: 2014-03-06 12:32:49 +0900
comments: true
tags:
- CoffeeScript
publish: false
---

## 即時関数の引数に別名をつける
jQuery のプラグイン書くときとかに使う。
{{% highlight coffeescript %}}
do ($ = jQuery) ->
  console.log $
{{% /highlight %}}
↓コンパイル
{{% highlight javascript %}}
(function($) {
  return console.log($);
})(jQuery);
{{% /highlight %}}


## オブジェクトリテラルでオブジェクトを作る
{{% highlight coffeescript %}}
a = 3
b = true
c = 'bar'
console.log { a, b, c }  # => { a: 3, b: true, c: 'bar' }
{{% /highlight %}}


## 分解代入で纏めて変数宣言
{{% highlight coffeescript %}}
a = b = c = null
{{% /highlight %}}
の代わりに下記のように書くことができる。
{{% highlight coffeescript %}}
[ a, b, c ] = []
{{% /highlight %}}
↓コンパイル
{{% highlight javascript %}}
var a, b, c, _ref;

_ref = [], a = _ref[0], b = _ref[1], c = _ref[2];
{{% /highlight %}}


## superを引数付きでコールする
`super()`ではなく`super`と書くことで引数を引き継いでコールしてくれる。
{{% highlight coffeescript %}}
class Foo
  constructor: (@a) ->
class Bar extends Foo
  constructor: ->
    super
bar = new Bar 3
console.log bar.a  # => 3
{{% /highlight %}}
便利な反面、`super`と書いた時点で継承元の関数が実行されることに気をつけなければならない。
{{% highlight coffeescript %}}
class Foo
  func: ->
    console.log 'executed!!'
    'foo'
class Bar extends Foo
  func: ->
    @superFunc = super
    console.log @superFunc
bar = new Bar()
bar.func()  # => 'executed!!'
            # => 'foo'
{{% /highlight %}}
このように`super`を`@superFunc`に格納するつもりで書いたコードを実行すると、
`super`を実行した戻りが`@superFunc`に格納されることになる。


## 比較演算子
比較が捗る。
{{% highlight coffeescript %}}
a <= b < c
{{% /highlight %}}
↓コンパイル
{{% highlight javascript %}}
(a <= b && b < c);
{{% /highlight %}}



## 分解代入とクラスのthis代入の合わせ技
{{% highlight coffeescript %}}
class Foo
  constructor: ({@a})->

foo = new Foo a: 3
console.log foo.a  # => 3
{{% /highlight %}}


## Array comprehensionsのシュガー
ワンライナーで。
{{% highlight coffeescript %}}
countdown = (num for num in [10..1])
{{% /highlight %}}
即時関数で。
{{% highlight coffeescript %}}
countdown = do -> num for num in [10..1]
{{% /highlight %}}


## 引数の並置
{{% highlight coffeescript %}}
a 1, 2, 3
a 1,
  2,
  3
a 1,
  2
  3
{{% /highlight %}}
↓コンパイル
{{% highlight javascript %}}
a(1, 2, 3);
{{% /highlight %}}
