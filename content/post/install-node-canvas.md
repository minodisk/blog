+++
date = 2014-03-25T09:45:30Z
title = "Install node-canvas"
tags = [
  "Node"
]
+++

依存パッケージをインストールしておかないと`node-canvas`のインストールでコケる。

## CentOS

{{% highlight bash %}}
yum install cairo cairo-devel cairomm-devel libjpeg-turbo-devel pango pango-devel pangomm pangomm-devel giflib-devel
npm install canvas
{{% /highlight %}}

## MacOSX

{{% highlight bash %}}
brew install cairo
export PKG_CONFIG_PATH=/opt/X11/lib/pkgconfig
npm install canvas
{{% /highlight %}}
