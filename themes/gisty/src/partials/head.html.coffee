head ->
  meta charset: 'utf-8'
  title if @document.title then "#{@site.title} | #{@document.title}" else @site.title
  link href: '/styles/io.css', rel: 'stylesheet'
  @getBlock('scripts').toHTML()
