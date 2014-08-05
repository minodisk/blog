+++
date = 2014-08-05T04:14:57Z
draft = true
title = "Gulpでシリアルなタスクを作る"
tags = [
  "Gulp"
]
+++

アンドキュメントじゃね？ってことで書いた。

「タスクに関わるファイルが更新されたら、CoffeeScriptをコンパイルしてからmochaでテストする」というパターンを例にします。

# gulpだけで解決するパターン

```
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

[`Stream#on('end')`](http://nodejs.org/api/stream.html#stream_event_end) でタスクの終了を待ってから `gulp.start()` で次のタスクを開始します。

# [run-sequence](https://github.com/OverZealous/run-sequence) を使うパターン

```
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

`run-sequence` で `'coffee'` と `'mocha'` を順に実行するタスクを新たに作ります。
タスクの中に次のタスクを書かないことでタスク同士の依存性が減るので、タスクの組み合わせが何通りかある場合は使い勝手が良いかもしれません。

## 参考サイト

- [[Gulp.js] タスク単位のファイル分割 ｜ Developers.IO](http://dev.classmethod.jp/client-side/javascript/gulp-js-task-files/)
