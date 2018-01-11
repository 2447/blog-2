module.exports = (file, h1, html, git)->
    {F} = PP
    html = html.replaceAll('="'+F, '="'+F.slice(-3))
    opt = {
        file
        h1
        html
    }
    if git != undefined
        opt.git = git
    PP.post(
        "post"
        opt
    )
