+++
date = 2014-08-05T07:11:21Z
draft = true
title = "GulpでJade"
tags = [
  "gulp",
  "gulp.watch",
  "gulp.start",
  "gulp-debug",
  "gulp-cached",
  "gulp-jade",
  "gulp-if",
  "gulp-cached"
]
+++

Jadeのコンパイルを紹介します。

# 設定

Jadeのコンパイルでは`include`やdataの出力を伴うので、ファイルの変更時に必要なファイルだけをコンパイルしようとするとそれなりにgulpfileを書く必要があります。

## 構成

```
.
├── jade
│   ├── data
│   ├── partials
│   └── templates
└── gulpfile.coffee
```

## gulpfile.coffee

```coffeescript
gulp = require 'gulp'
debug = require 'gulp-debug'
cached = require 'gulp-cached'
gulpif = require 'gulp-if'
jade = require 'gulp-jade'

shouldBeJadeCached = true

gulp.task 'jade', ->
  gulp
  .src 'jade/templates/**/*.jade'
  .pipe gulpif shouldBeJadeCached, cached 'jade'
  .pipe debug()
  .pipe jade pretty: true
  .pipe gulp.dest 'htdocs'

gulp.task 'watch', ->
  gulp.watch 'jade/templates/**/*.jade', (e) ->
    shouldBeJadeCached = true
    gulp.start 'jade'
  gulp.watch [
    'jade/partials/**/*.jade'
    'jade/data/**/*.*'
  ], (e) ->
    shouldBeJadeCached = false
    gulp.start 'jade'

gulp.task 'default', [
  'jade'
  'watch'
]
```

`jade`タスク内では`gulp-if`でキャッシュと比較するかを判定し、必要なら`gulp-cached`でキャッシュから変更があるファイルのみをパイプします。

`watch`タスク内では`gulp.watch`のオプションにコールバックを登録することができることを利用しています。
テンプレートのベースとなるファイルが変更された時は、キャッシュ比較のフラグを立ててから`jade`タスクをスタートし、
テンプレートのベースにインクルードされるファイルやデータ用のファイルが変更されたら、キャッシュ比較のフラグを倒してから`jade`タスクをスタートします。

※ `gulp-debug`はどのファイルに処理を行うのかトレースしてくれるプラグインです。
gulpfile完成後は必要ないと思うのでコメントアウトするとよいでしょう。

# タスクに引数を渡せないの？

`jade`タスクにしか関係の無い`shouldBeJadeCached`をグローバルなところに置いているのが若干の気持ち悪さがあります。
gruntみたいにタスクに引数渡せればと思いましたが、コラボレータのphatedが「タスクにパラメータをサポートして欲しい」というスレッドで[否定的な意見](https://github.com/orchestrator/orchestrator/issues/17#issuecomment-33324929)を表明していて引数のサポートは今のところなさそうです。
