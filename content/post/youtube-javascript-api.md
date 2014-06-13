---
layout: post
title: "YouTube JavaScript API"
date: 2014-02-05 01:38:53 +0900
comments: true
tags: [JavaScript, YouTube, API]
---
YouTubeをembedするとJavaScriptのAPIが使えるようになります。
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js"></script>
<div id="ytapiplayer">
  You need Flash player 8+ and JavaScript enabled to view this video.
</div>
<div id="log" style="height:150px;overflow-y:scroll;white-space:pre-wrap;font-family:monospace;font-size:12px;line-height:16px;">
</div>
<script type="text/javascript">
var STATES = {
  '-1': '未開始',
  '0': '終了',
  '1': '再生中',
  '2': '一時停止中',
  '3': 'バッファリング中',
  '5': '頭出し済み'
};
var params = { allowScriptAccess: "always" };
var atts = { id: "myytplayer" };
swfobject.embedSWF(
  "http://www.youtube.com/v/u1zgFlCw8Aw?enablejsapi=1&playerapiid=ytplayer",
  "ytapiplayer", "425", "356", "8", null, null, params, atts
  );
var $log = $('#log');

function onYouTubePlayerReady(playerId) {
  var ytplayer = document.getElementById("myytplayer");
  ytplayer.addEventListener('onStateChange', 'onStateChange');
}
function onStateChange(state) {
  log('onStateChange:', state, '=', STATES['' + state]);
}
function log() {
  $log
    .text($log.text() + Array.prototype.join.call(arguments, ' ') + '\n')
    .scrollTop($log.prop('scrollHeight'));
}
</script>

## ExternalInterface に関する Tips

YouTube JavaScript API からは `ExternalInterface.call` 経由で JavaScript がコールされる。
このAPIに限らず `ExternalInterface.call` を使う際に共通の注意点だが、FlashPlayer は JavaScript のメソッドのその戻りを待っている間レンダリングをやめてしまう。
対策として、JavaScript から何も返さない場合は次のイベントループで処理を行い、関数自体は `return` して FlashPlayer のレンダリングを再開させてあげるのがスムーズに見える。

{{% highlight javascript %}}
function onStateChange(state) {
  setTimeout(function () {
    log();
  });
  return;
}
{{% /highlight %}}
