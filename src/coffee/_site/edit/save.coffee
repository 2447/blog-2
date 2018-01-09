module.exports = (file, h1, html, git)->
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
