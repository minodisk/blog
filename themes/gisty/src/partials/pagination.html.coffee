div '.pagination', ->
  ul ->
    unless @hasPrevPage()
      li '.disabled', ->
        span '&laquo;'
    else
      li ->
        a href: @getPrevPage(), '&laquo;'

    shownSize = @document.pageShownSize
    targetIndex = @document.page.number
    min = 0
    max = @document.page.count - 1
    arounds = [ [], [] ]
    i = targetIndex
    while i-- > min
      arounds[0].push i
    i = targetIndex
    while i++ < max
      arounds[1].push i
    pageIndexes = [ targetIndex ]
    iAround = 0
    while pageIndexes.length < shownSize
      break if @_.flatten(arounds).length is 0
      around = arounds[iAround++ % 2]
      continue if around.length is 0
      pageIndexes.push around.shift()
    pageIndexes.sort (a, b) -> a - b

    for index in pageIndexes
      if index is targetIndex
        li '.active', ->
          span index + 1
      else
        li ->
          a href: @getPageUrl(index), index + 1

    unless @hasNextPage()
      li '.disabled', ->
        span '&raquo;'
    else
      li ->
        a href: @getNextPage(), '&raquo;'
