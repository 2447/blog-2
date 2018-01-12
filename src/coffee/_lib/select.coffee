EVENT_CLICK='click.menu'

dropdown = (html, click, bind)->
    input = $ @
    input.attr {
        autocomplete:'off'
    }
    doc = $ document
    select = input.parents('.SELECT')
    _click = ->
        me = $ @
        r = click.call(me, input)
        if $.isArray(r)
            [v, t] = r
        else
            if typeof(r) == 'string'
                t = r
            else
                t = me.text()
            v = @dataset.v
        input.val t
        input[0].dataset.v = v
        return false
    input.focus =>
        menu = select.find('.menu')
        if menu[0]
            menu.remove()
        else
            menu = $('<div class=menu/>')
            menu.html html
            bind.call menu, input
            setTimeout(
                ->
                    doc.on(
                        EVENT_CLICK
                        (e)->
                            doc.off(EVENT_CLICK)
                            if $(e.target).closest('.menu')[0] != menu[0]
                                menu.remove()
                            return
                    )
                300
            )
            menu.find('.v').off(EVENT_CLICK).on(
                EVENT_CLICK
                ->
                    _click.call @
                    doc.off(EVENT_CLICK)
                    menu.remove()
            )
            # if $.isFunction(html)
            #     menu.append('<b class="I-loading"></b>')
            #     html().then (h)->
            #         menu.html(h)
            #         init()
            # else
            select.append(menu)
        input.blur()
    return

module.exports = (el_li, html, click, bind)->
    for i in el_li
        dropdown.call i, html, click, bind
