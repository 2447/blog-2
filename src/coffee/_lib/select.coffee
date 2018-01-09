EVENT_CLICK='click.menu'

dropdown = (html, click, bind)->
    input = $ @
    input.attr {
        autocomplete:'off'
    }

    input.focus =>
        select = input.parents('.SELECT')
        menu = select.find('.menu')
        if menu[0]
            menu.remove()
        else
            menu = $('<div class=menu/>')
            init = ->
                bind.call menu
                menu.find('.v').unbind(EVENT_CLICK).bind(
                    EVENT_CLICK
                    ->
                        me = $ @
                        r = click.call(me, input)
                        if $.isArray(r)
                            [v, t] = r
                        else
                            v = @dataset.v
                            t = me.text()
                        input.val t
                        input[0].dataset.v = v
                        menu.remove()
                )
            if $.isFunction(html)
                menu.append('<b class="I-loading"></b>')
                html().then (h)->
                    menu.html(h)
                    init()
            else
                menu.append html
                init()
            select.append(menu)
        input.blur()
    return

module.exports = (el_li, html, click, bind)->
    for i in el_li
        dropdown.call i, html, click, bind
