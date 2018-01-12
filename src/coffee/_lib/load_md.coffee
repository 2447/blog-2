marked = require('coffee/_lib/marked')
module.exports = (md)->
    md = (md or '').split("\n")
    title = ""
    while md.length
        i = md[0]
        if not $.trim(i)
            md.shift()
            continue
        if i.charAt(0) == "#"
            title = $.trim(md.shift().replace(/^#/g, ''))
        break
    {F} = PP
    return [
        title
        marked(md.join("\n")).replaceAll('="'+F.slice(-3), '="'+F)
    ]
