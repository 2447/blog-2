require 'scss/_init'
window.$ = window.jQuery = require "jquery"
history.pushState(
    null
    null
    location.pathname.slice(0,-5)
)
$ ->
    exit = ->
        location.href="/"
    close = $ """<i class="PboxIco I I-close"></i>"""

    $(".Pbox:first").append close

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
