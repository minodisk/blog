+++
date = 2014-03-07T03:36:01Z
title = "Path Animation"
draft = true
tags = [
  "JavaScript",
  "Snap.svg"
]
+++

## パスアニメーションとは
パスに沿ってオブジェクトを移動させるアニメーションのことです。
今回はSnap.svgでSVGをパースし、Illustratorで引いたパスに沿ってDOMを動かしてみます。

## 要点
Snap.svgはSVGで絵を書くだけではなく、外部SVGのパースを行うことが可能。
使用するライブラリの役割は以下のとおり。

- jQuery: DOM操作
- jQuery Transit: アニメーション
- Snap.svg: svgのパース

## 実装
{{% highlight javascript %}}
var fragment
  , ready = _.after(2, function () {
      var path = fragment.select('g').select('*')
        , totalLength = path.getTotalLength()
        , i = 0
        , point
        , $car = $('.car')
        ;

      // ダミー要素のtopを0からパスの全長までanimateします。
      // setIntervalを使って独自にアニメーションするよりも熟れたコードになり、
      // イージングを掛けられるようになるので表現の幅も容易に広がります。
      $('<div>')
        .animate({
          top: path.getTotalLength()  // パスの全長を取得
        }, {
          easing: 'easeOut',
          step: function (length) {
            var point = path.getPointAtLength(length)  // パスの現在の長さに対する座標を取得
              , x = point.x                            // x座標
              , y = point.y                            // y座標
              , alpha = point.alpha                    // パスの進む方向
              ;
            $car
              .css({
                x: x
                y: y
                rotate: alpha
              });
          })
        });
    })
    ;
})
;

// DOMのロード
$(document).one('ready', ready);
// SVGのロード
Snap.load('/data/2014-03-07-path-animation.svg', function (f) {
  fragment = f;
  ready();
});
{{% /highlight %}}
