+++
date = 2014-08-05T04:14:57Z
draft = true
title = "Gulpでシリアルタスク"
tags = [
  "gulp",
  "gulp.watch",
  "gulp.start"
]
+++

Gulpで直列的なタスクの書き方です。

# Why?

```coffeescript
gulp.task 'coffee&mocha', [
  'coffee'
  'mocha'
]
```
このように書くと並列的に実行されてしまい、テストされるコードのコンパイルが終わる前にテストが走ります。

# 例

「タスクに関わるファイルが更新されたら、CoffeeScriptをコンパイルした後mochaでテストする」
という事例で2つの方法を紹介します。

## gulpだけで解決する方法

[`Stream#on('end')`](http://nodejs.org/api/stream.html#stream_event_end) でタスクの終了を待ってから `gulp.start()` で次のタスクを開始します。

```coffeescript
gulp = require 'gulp'
coffee = require 'gulp-coffee'
mocha = require 'gulp-mocha'

files =
  src: 'src/**/*.coffee'
  test: 'test/**/*.coffee'

gulp.task 'watch', ->
  gulp.watch files.src, [
    'coffee'
  ]
  gulp.watch files.test, [
    'mocha'
  ]

gulp.task 'coffee', ->
  gulp
  .src files.src
  .pipe coffee bare: true
  .pipe gulp.dest 'lib'
  .on 'end', ->
    gulp.start 'mocha'

gulp.task 'mocha', ->
  gulp
  .src files.test, read: false
  .pipe coffee bare: true
  .pipe mocha reporter: 'tap'

gulp.task 'default', [
  'watch'
  'coffee'
]
```

## [run-sequence](https://github.com/OverZealous/run-sequence) を使う方法

`run-sequence` で `'coffee'` と `'mocha'` を順に実行するタスクを作ります。
タスク同士の依存性が減るので、タスクの組み合わせが何通りかある場合は使い勝手が良いかもしれません。

```coffeescript
gulp = require 'gulp'
coffee = require 'gulp-coffee'
mocha = require 'gulp-mocha'
sequence = require 'run-sequence'

files =
  src: 'src/**/*.coffee'
  test: 'test/**/*.coffee'

gulp.task 'watch', ->
  gulp.watch files.src, [
    'coffee&mocha'
  ]
  gulp.watch files.test, [
    'mocha'
  ]

gulp.task 'coffee&mocha', (callback) ->
  sequence 'coffee', 'mocha', callback

gulp.task 'coffee', ->
  gulp
  .src files.src
  .pipe coffee bare: true
  .pipe gulp.dest 'lib'

gulp.task 'mocha', ->
  gulp
  .src files.test, read: false
  .pipe coffee bare: true
  .pipe mocha reporter: 'tap'

gulp.task 'default', [
  'watch'
  'coffee&mocha'
]
```

# 参考サイト

- [[Gulp.js] タスク単位のファイル分割 ｜ Developers.IO](http://dev.classmethod.jp/client-side/javascript/gulp-js-task-files/)
