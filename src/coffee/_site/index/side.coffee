module.exports = ->
    html = $ require('slm/index/side').render(SITE)
    slide = require('coffee/_lib/slideout')(
        $ '.Page'
        html
        "Right"
    )
    PP.get(
        "-/md/!/SUMMARY.md"
        (txt)->
            _ = $.html()
            _ "<div>"
            for i in txt.split("\n")
                if i.startsWith('* ')
                    [name, link]  = i.slice(2).trim().split("](")
                    link = link.slice(0,-4)
                    name = name.slice(1) or link
                    _ """<div class="a"><a href="/!#{link}">#{$.escape name}</a></div>"""
            _ "</div>"
            ali = $ _.html()
            if PP.open
                System.import("coffee/_pp/index/side").then(
                    (f)->f(ali,slide)
                )
            ali.find('a').click -> slide.close()
            html.find('.VC .MENU').html ali

    )
