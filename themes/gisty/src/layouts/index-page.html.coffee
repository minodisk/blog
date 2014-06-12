doctype 5
html lang: 'en', ->
  text @partial 'head'
  body ->
    div class: 'container', ->
      text @partial 'header'

      div '.content', ->
        ul ->
          posts = @getPageCollection('posts').toJSON()
          for post in posts
            li ->
              a href: post.url, post.title
        text @partial 'pagination'

      text @partial 'footer'
