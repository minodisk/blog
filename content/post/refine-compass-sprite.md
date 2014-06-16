+++
date = 2014-06-15T06:04:06Z
title = "CompassのSprite生成処理を改良する"
tags = [
  "Compass",
  "Ruby"
]
links = [
  "http://stackoverflow.com/questions/9183133/how-to-turn-off-compass-sass-cache-busting",
  "http://blog.webcreativepark.net/2012/12/03-135619.html"
]
+++

キャッシュバスターの文字列が画像名に入ったスプライト画像が生成される問題を、
パフォーマンスを損なわずに解決する方法。

## Compassでスプライト画像を書き出す際の問題点

スプライト画像が`*-s[画像バイナリのMD5ハッシュ].png`の様に画像名内にキャッシュバスターが入ることで、スプライト画像に変更が入ると画像名が変わってしまう。これはバージョン管理や差分管理する上で不都合となることが多い。
このハッシュは`background-image:url();`で指定した画像を変更する際に、ブラウザがキャッシュを参照しないようにキャッシュ対策(キャッシュバスターと呼ばれている)として入れられている文字列だ。

## コールバックを使う方法で生まれる問題点

Compassに用意されているコールバックを使った既出の解決法がある。

[css - How to turn off COMPASS SASS cache busting? - Stack Overflow](http://stackoverflow.com/questions/9183133/how-to-turn-off-compass-sass-cache-busting#answer-9332472)

この方法では、`on_sprite_saved`コールバックでスプライト画像をリネームし、`on_stylesheet_saved`でコンパイルされたCSSを書き直している。
これはコードとしての独立性が高く、キャッシュバスターを有効にしたままスプライト画像の画像名からハッシュを取り除く上手い方法だが、CSSを書き直す度にスプライト画像が書き出されてしまい<sup>[1](#1)</sup>Compassの処理完了までに時間がかってしまう。

1. <span id="1"></span>Compassには前回書き出したスプライト画像を[書き出し直す必要があるかを検査する機構](https://github.com/chriseppstein/compass/blob/v0.12.2/lib/compass/sass_extensions/sprites/sprite_methods.rb#L78-L81)があり、[ファイルが存在しない場合書き出し直す](https://github.com/chriseppstein/compass/blob/v0.12.2/lib/compass/sass_extensions/sprites/sprite_methods.rb#L58-L64)という処理を行っている。

## モンキーパッチで解決する

Compass v0.12.2 で動作確認。

スプライト画像のファイル名にハッシュを入れない代わりに、CSSコンパイル時に`*.png?[画像バイナリのMD5ハッシュ]`のようにサーチクエリをつけて書き出す。
「コールバックを使う方法」と処理結果は同じだが、Sassリコンパイル時にスプライト画像を再生成しないので前述の問題が発生しない。

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

「コールバックを使う方法」採用時はスプライト画像を多く使うプロジェクトでは、コンパイル時に時間が掛かることでSassの編集作業にストレスを感じることが多かった。
作業軽減のために採用したCompassの利用でストレスを感じるのは本末転倒なので、この方法を採用したことで得られるものは大きかった。

ただし、この方法は`Compass`モジュールのバージョンが変わったら動かなくなる可能性は十分にあるので注意が必要だ。
