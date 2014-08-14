+++
date = 2014-08-04T10:52:10Z
draft = true
title = "mochaでCoveralls"
tags = [
  "Node",
  "Mocha",
  "Coveralls",
  "CoffeeScript"
]
+++

TravisCI終わりに `istanbul`と`mocha`で Coveralls のバッジ作る方法です。

# 設定順序

テストは通ってる前提で。

1. 必要なパッケージをインストール
2. istanbulでカバレッジを出力するテスト
3. package.jsonにcoveralls用のスクリプトを設定
4. .travis.ymlにテスト後にcoverallsスクリプトを呼ぶように設定
5. Coverallsで設定
6. `git push`

## 1. 必要なパッケージをインストール

```
$ npm install -D coveralls istanbul mocha-lcov-reporter
```

## 2. istanbulでカバレッジを出力するテスト

```
$ istanbul cover _mocha --report lcovonly -- -R spec && rm -rf ./coverage
```

※ CoffeeScriptのコンパイルが必要な場合

```
$ coffee -c test && istanbul cover _mocha --report lcovonly -- -R spec && rm -rf ./coverage ./test/*.js
```

## 3. package.jsonにcoveralls用のスクリプトを設定

```
  ...
  "scripts": {
    "coveralls": "istanbul cover _mocha --report lcovonly -- -R spec && cat ./coverage/lcov.info | coveralls && rm -rf ./coverage"
  },
  ...
```

※ CoffeeScriptのコンパイルが必要な場合

```
  ...
  "scripts": {
    "coveralls": "coffee -c test && istanbul cover _mocha --report lcovonly -- -R spec && cat ./coverage/lcov.info | coveralls && rm -rf ./coverage ./test/*.js"
  },
  ...
```

## 4. .travis.ymlにテスト後にcoverallsスクリプトを呼ぶように設定

```
language: node_js
node_js:
  - 0.10
after_script:
  - npm run coveralls
```

## 5. Coverallsで設定
## 6. `git push`
