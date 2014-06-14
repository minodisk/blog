+++
date = 2014-04-03T05:29:57Z
title = "Access to title in IE8"
tags = [
  "jQuery",
  "JavaScript"
]
+++

jQueryではIE8で`title`へのアクセスができないので直接アクセスする。

{{% highlight javascript %}}
$('title').text('foo');
{{% /highlight %}}
{{% highlight javascript %}}
document.title = 'foo';
{{% /highlight %}}
