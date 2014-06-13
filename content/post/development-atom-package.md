---
layout: post
title: "AtomEditorのパッケージ開発"
date: 2014-04-03 15:03:15 +0900
comments: true
tags:
- Atom
---

逆引き的ななにか。


## Package書くときに使う

### パッケージのSettingsにチェックボックスを表示する
{{% highlight coffeescript %}}
module.exports =
  configDefaults:
    highlightReference: true
    highlightError    : true
{{% /highlight %}}

### 文法がCoffeeScriptかを調べる
* `Grammar::scopeName`

{{% highlight coffeescript %}}
editor = atom.workspaceView.getActiveEditor()
scopeName = @editor.getGrammar().scopeName
console.log scopeName is 'source.coffee' or scopeName is 'source.litcoffee'
{{% /highlight %}}

### カーソル下の単語の範囲の取得する
* `Cursor::getCurrentWordBufferRange()`

{{% highlight coffeescript %}}
editor = atom.workspaceView.getActiveEditor()
cursor = editor.cursors[0]
range = cursor.getCurrentWordBufferRange includeNonWordCharacters: false
{{% /highlight %}}

### WorkspaceView#commandをoffする
`WorkspaceView#command()`では`WorkspaceView.data('documentation')`にeventName/docStringを登録してるだけで、イベント自体はjQueryの`on()`で聞いてる。
よってoffしたい時は普通に`WorkspaceView#off()`すればよい。
{{% highlight coffeescript %}}
atom.workspaceView.command 'hoge:action', handler
atom.workspaceView.off 'hoge:action', handler
{{% /highlight %}}


## Spec書く時に使う

### CoffeeScriptの言語パッケージをロードする
* `PackageManager::resolvePackagePath(packageName)`: パッケージ名からパッケージのパスを取得する
* `Syntax::loadGrammarSync(grammarPath)`: 言語パッケージをロードする

{{% highlight coffeescript %}}
languageCoffeeScriptPath = atom.packages.resolvePackagePath 'language-coffee-script'
grammarDir = path.resolve languageCoffeeScriptPath, 'grammars'
for filename in fs.readdirSync grammarDir
  atom.syntax.loadGrammarSync path.resolve grammarDir, filename
{{% /highlight %}}


## 参考サイト
- [Atom API Documentation](https://atom.io/docs/api/)
- [atom.io events](https://gist.github.com/ardcore/9262498)
