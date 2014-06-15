+++
date = 2014-06-15T06:04:06Z
title = "Compassを改良する"
tags = [
  "Compass",
  "Ruby"
]
links = [
  "http://stackoverflow.com/questions/9183133/how-to-turn-off-compass-sass-cache-busting"
]
+++

キャッシュバスターの文字列が画像名に入ったスプライト画像が生成される問題を、
パフォーマンスを損なわずに解決する方法。

## 問題点

スプライト画像の画像名内にキャッシュバスターが入ることで、
スプライト画像に変更が入ると画像名が変わってしまう。
バージョン管理や差分管理する上で不都合。

## コールバックを使う方法で生まれる問題点

既出の方法で`on_sprite_saved`コールバックでスプライト画像をリネームし、
`on_stylesheet_saved`でコンパイルされたCSSを書きなおすという解決法がある。
これはCompassのAPIに則った独立性の高い方法だが、
CSSを書き直す度にスプライト画像が書き出され
Sassの保存からCSSコンパイル完了までに時間がかってしまう。

[css - How to turn off COMPASS SASS cache busting? - Stack Overflow](http://stackoverflow.com/questions/9183133/how-to-turn-off-compass-sass-cache-busting#answer-9332472)

## モンキーパッチで根本的に解決する

Compass v0.12.2 で動作確認。
スプライト画像が`*-s[画像バイナリのMD5ハッシュ].png`として生成され、
スプライトのソース画像に変更が入る度にスプライト画像名が変わってしまう問題に対応。
元々このハッシュはキャッシュ対策(キャッシュバスター)として入れられているものなので、
画像名内のハッシュを削除する代わりにCSSコンパイル時に`*.png?[画像バイナリのMD5ハッシュ]`
のようにサーチクエリをつけて書き出すことで代替する。

{{% highlight ruby %}}
module Compass
  module SassExtensions
    module Functions
      module Sprites
        # CSSコンパイル時にハッシュをサーチクエリにつける
        def sprite_url(map)
          verify_map(map, "sprite-url")
          map.generate
          generated_image_url(Sass::Script::String.new("#{map.path}.png?#{map.uniqueness_hash}"))
        end
      end
    end
    module Sprites
      module SpriteMethods
        # ハッシュ抜きのファイル名を返す
        def name_and_hash
          "#{path}.png"
        end
        # ハッシュ入りの画像ファイルは書き出されなくなっているはずなので古いファイルの削除は行わない
        def cleanup_old_sprites
          # do nothing
        end
      end
    end
  end
end
{{% /highlight %}}

## まとめ

スプライト画像を多く使うプロジェクトでは、コンパイル時に時間が掛かることで
Sassの編集作業がストレスを感じる作業になりがちだった。
作業軽減のために採用したCompassの利用でストレスを感じるのは本末転倒なので、
多少汚い方法でも今回紹介した方法を使ってみるとよいかと思う。
ただし、この方法は`Compass`と`Sass`モジュールのバージョンが変わったら
動かなくなる可能性は十分にあるので注意。
