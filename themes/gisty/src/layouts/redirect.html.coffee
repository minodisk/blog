redirectUrl = @document.redirectUrl
unless redirectUrl?
  if (latestPost = @getPageCollection('posts').toJSON()[0])?
    redirectUrl = latestPost.url
  else
    redirectUrl = '/'

doctype 5
html lang: 'en', ->
  head ->
    meta 'http-equiv': 'refresh', content: "0;url=#{redirectUrl}"
    link href: redirectUrl, rel: 'canonical'
    coffeescript ->
      location.replace redirectUrl
