+++
date = 2014-08-04T06:12:39Z
draft = true
title = "GulpでHTMLを再構築する"
tags = [
  "gulp",
  "gulp-html-rebuild",
  "HTML",
  "HTMLParser"
]
+++

HTMLをパースしつつ、変更を加えたノードでHTMLを構築し直すプラグインの紹介です。

# このプラグインがすること

htmlをパースして、タグ開始・テキストノード・タグ終了時等に登録されたコールバックを呼び、戻りの文字列からhtmlを再構築します。
htmlをパースするので、正規表現では辛めのノード単位での整形が可能です。

{{% highlight html %}}
<div class="article article-single">
  <h1>abc</h1>
  <p>def</p>
</div>
{{% /highlight %}}
↓閉じタグ直前にクラス名を羅列したコメントを追加したり
{{% highlight coffeescript %}}
gulp.task 'rebuild', ->
  rebuild
    ontagclose: (name, attrs) ->
      return unless attrs.class? # nullを返すとデフォルトの処理を行います
      comment = (".#{cls}" for cls in attrs.class.split(/\s+/g)).join('')
      "<!-- /#{comment} --></#{name}>"
{{% /highlight %}}
↓
{{% highlight html %}}
<div class="article article-single">
  <h1>abc</h1>
  <p>def</p>
<!-- /.article.article-single --></div>
{{% /highlight %}}

{{% highlight html %}}
<div class="article article-single">
  <h1>abc</h1>
  <p>def</p>
</div>
{{% /highlight %}}
↓特定のクラス名が付いているとタグ名に変換したり
{{% highlight html %}}
<article class="single">
  <h1>abc</h1>
  <p>def</p>
</article>
{{% /highlight %}}

DOMを解釈してるわけじゃないので親・兄弟・先祖・子孫のノードへの処理は不可能です。

# htmlparser

fb55/htmlparser2 のstackをObjectで登録することで閉じタグにも属性値を取り出せるようにしたフォーク minodisk/htmlparser2#stack-storage でパースします。
フォーク元に付いてたRSSとかのパースのテストも通ってるのでRSSとかも書き換えれるかもです。

### *作ったきっかけ*

*まずはじめにこれから書くことは全てフィクションです。
「特定タグに付けられたクラス名を閉じタグ前にコメントとして羅列する」というコーディング規約を読んだ時、何を思い浮かべますか。*

- *どこで閉じてるか明白なインデントを規約にする方が合理的では？*
- *ノードの開始と終了位置くらいエディタがハイライトしてくれるでしょ。*
- *そもそも閉じタグとかいう概念が存在しないJadeとかありますけど。*

*それでも強いられる根拠の無いコーディング規約。そんな時に使えばいいんじゃないでしょうか。（適当）*
