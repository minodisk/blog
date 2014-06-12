doctype 5
html lang: 'en', ->
  text @partial 'head'
  body ->
    div '.wrapper', ->

      text @partial 'header'

      div '.body', ->
        div '.container', @content

      text @partial 'footer'
