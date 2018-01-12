module.exports = (file, h1, html, option)->
    {F} = PP
    html = html.replaceAll('="'+F, '="'+F.slice(-3))
    opt = {
        file
        h1
        html
    }
    $.extend(opt, option)
    PP.post(
        "post"
        opt
    )
