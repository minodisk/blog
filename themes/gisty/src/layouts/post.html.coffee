doctype 5
html lang: 'en', ->
  text @partial 'head'
  body ->
    div '.wrapper', ->

      text @partial 'header'

      div '.body', ->
        div '.container', ->
          article -> #'.autopagerize_page_element', ->
            h1 ->
              a href: @document.url, @document.title
            table '.meta', ->
              thead ->
                tr ->
                  th 'History'
                  th 'Posted Date'
                  th 'Modified Date'
                  th 'Tags'
              tbody ->
                tr ->
                  td ->
                    a href: "#{@repository.history}#{@document.relativePath}", target: '_blank', 'History'
                  td ->
                    span @moment(@document.date).format('YYYY-MM-DD HH:mm:ss ZZ')
                  td ->
                    span @moment(@getLatestCommit(@document) ? @document.date).format('YYYY-MM-DD HH:mm:ss ZZ')
                  td ->
                    ul ->
                      for tag in @document.tags
                        li '.tag', tag
            @document.contentRenderedWithoutLayouts
          div '.related', ->
            h4 'Related Posts'
            ul ->
              for document in @getRelatedDocuments()
                li ->
                  a href: document.url, document.title
          text @partial 'post-pagination'
          div '.disqus', @getDisqus()

      text @partial 'footer'
