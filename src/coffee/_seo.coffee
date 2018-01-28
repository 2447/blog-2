require 'scss/_init'
window.$ = window.jQuery = require "jquery"

URL = location.pathname.slice(0,-4)
history.pushState(
    null
    null
    URL
)

require('coffee/_lib/analytics')

$ ->

    box = $(".Pbox:first")

    exit = ->
        location.href="/"

    close = $ """<i class="PboxIco I I-close"></i>"""
    box.append close

    close.click exit

    $(document).bind(
        'keyup.box'
        (e)->
            tagName = e.target.tagName
            if tagName != "TEXTAREA" and tagName != "INPUT"
                if e.keyCode == 27
                    exit()
            return
    )
    require(
        'coffee/_lib/8gua/ws'
    ) ->
        if PP.open
            System.import(
                "coffee/_pp/post/edit"
            ).then(
                (mod)=>
                    url = URL.slice(1)
                    if url.slice(0,2) == "-/"
                        url = url.slice(2)
                    mod(
                        url
                        box
                        exit
                    )
            )
