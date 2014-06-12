ul '.post-pagination', ->
  documents = @getCollection('posts').toJSON()
  for document, i in documents
    if @document.id is document.id
      if i isnt 0
        li '.prev', ->
          prev = documents[i - 1]
          a rel: 'prev', href: prev.url, "#{prev.title}"
      if i isnt documents.length - 1
        li '.next', ->
          next = documents[i + 1]
          a rel: 'next', href: next.url, "#{next.title}"
      break
