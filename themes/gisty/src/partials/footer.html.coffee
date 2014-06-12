footer '.footer', ->
  div '.container', ->
    ul '.footer-links', ->
      li "&copy;#{@site.date.getFullYear()} #{@auther.name}"
      # li ->
      #   a href: '/archive', 'Archive'
      # li ->
      #   a href: '/tags', 'Tags'
      li ->
        a href: '/rss.xml', 'RSS'
