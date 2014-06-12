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
```coffeescript
do ($ = jQuery) ->
  console.log $
```
↓コンパイル
```javascript
(function($) {
  return console.log($);
})(jQuery);
```


## オブジェクトリテラルでオブジェクトを作る
```coffeescript
a = 3
b = true
c = 'bar'
console.log { a, b, c }  # => { a: 3, b: true, c: 'bar' }
```


## 分解代入で纏めて変数宣言
```coffeescript
a = b = c = null
```
の代わりに下記のように書くことができる。
```coffeescript
[ a, b, c ] = []
```
↓コンパイル
```javascript
var a, b, c, _ref;

_ref = [], a = _ref[0], b = _ref[1], c = _ref[2];
```


## superを引数付きでコールする
`super()`ではなく`super`と書くことで引数を引き継いでコールしてくれる。
```coffeescript
class Foo
  constructor: (@a) ->
class Bar extends Foo
  constructor: ->
    super
bar = new Bar 3
console.log bar.a  # => 3
```
便利な反面、`super`と書いた時点で継承元の関数が実行されることに気をつけなければならない。
```coffeescript
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
```
このように`super`を`@superFunc`に格納するつもりで書いたコードを実行すると、
`super`を実行した戻りが`@superFunc`に格納されることになる。


## 比較演算子
比較が捗る。
```coffeescript
a <= b < c
```
↓コンパイル
```javascript
(a <= b && b < c);
```



## 分解代入とクラスのthis代入の合わせ技
```coffeescript
class Foo
  constructor: ({@a})->

foo = new Foo a: 3
console.log foo.a  # => 3
```


## Array comprehensionsのシュガー
ワンライナーで。
```coffeescript
countdown = (num for num in [10..1])
```
即時関数で。
```coffeescript
countdown = do -> num for num in [10..1]
```


## 引数の並置
```coffeescript
a 1, 2, 3
a 1,
  2,
  3
a 1,
  2
  3
```
↓コンパイル
```javascript
a(1, 2, 3);
```
