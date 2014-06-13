---
layout: post
title: "CoffeeScript Compiler"
date: 2014-05-02 10:37:03 +0900
comments: true
tags:
- CoffeeScript
---

[minodisk/coffee-refactor](https://github.com/minodisk/coffee-refactor)を作成中に[index.coffee](http://coffeescript.org/documentation/docs/)を読んでわかったことのメモ。

## nodes.coffee

### Code#compileNode()

ノードをコンパイルする。
コンパイルの過程で`Scope`インスタンスが作成される。
オプションに親のスコープを渡すと`variables`は親のスコープ内で宣言された変数を考慮した変数のリストとなる。

{{% highlight coffeescript %}}
options =
  scope: parent.scope
  indent: ''
code.compileNode options
scope = options.scope
console.log scope.variables
{{% /highlight %}}

## scope.coffee

### Scope#declaredVariables()

スコープ内で`var`で宣言される変数の配列を返す。パラメータは含まれない。

スコープ内で定義される全ての名前空間を取得するためには、さらにパラメータを含む必要が有るため下記のコードを使う。
{{% highlight coffeescript %}}
declaredSymbols = (scope) ->
  realVars = []
  tempVars = []
  for v in @variables when v.type is 'var' or v.type is 'param'
    (if v.name.charAt(0) is '_' then tempVars else realVars).push v.name
  realVars.sort().concat tempVars.sort()
{{% /highlight %}}
