h1_html = require('coffee/_lib/marked/h1_html')

module.exports = (md)->
    [h1, html] = h1_html(md)
    {F} = PP
    return [
        h1
        html.replaceAll('="'+F.slice(-3), '="'+F)
    ]
