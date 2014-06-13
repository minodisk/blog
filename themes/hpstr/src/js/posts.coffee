map = {}
$ 'article'
.each ->
  $el = $ @
  id = $el.find 'h2'
  .attr 'id'
  unless map[id]
    map[id] = $el
  else
    $target = map[id]
    $el.find 'li'
    .appendTo $target.find 'ul'
    $el.remove()
