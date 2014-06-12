---
layout: post
title: "Access to title in IE8"
date: 2014-04-03 14:29:57 +0900
comments: true
tags:
- jQuery
- JavaScript
---

jQueryではIE8で`title`へのアクセスができないので直接アクセスする。

```javascript
$('title').text('foo');
```
```javascript
document.title = 'foo';
```
