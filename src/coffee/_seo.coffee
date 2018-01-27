require 'scss/_init'
window.$ = window.jQuery = require "jquery"
URL = location.pathname.slice(0,-5)
history.pushState(
    null
    null
    URL
)
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
    if PP.open
        require(
            'coffee/_lib/8gua/ws'
        ) ->
            System.import(
                "coffee/_pp/post/edit"
            ).then(
                (mod)=>
                    mod(
                        URL
                        box
                        exit
                    )
            )
