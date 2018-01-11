ing = undefined

$.pbox = (html, option={})->
    if ing
        return
    ing = 1
    doc = $(document)
    option = {
        className:"PboxMain"
        ico:"close"
        keyup:(keyCode, tagName)->
            if tagName != "TEXTAREA" and tagName != "INPUT"
                if keyCode == 27
                    rm()
            return
        ...option
    }
    className = option.className
    elem = $("""<div class="Pbox #{option.classPbox or ''}"><div class="C macS"><div class="#{className}"></div></div><i class="PboxIco I I-#{option.ico}"></i></div>""")
    elem.find('.'+className).html html
    $('body').append(elem)

    scrollbar = $.scrollbar(
        elem.find('.macS')[0]
    )

    keyup = 'keyup.box'
    _title = document.title
    rm = ->
        event = jQuery.Event("rm")
        elem.trigger(event)
        # c = option.rm
        # if c
        #     if c.call(@, _rm) == false
        #         return
        if not event.isDefaultPrevented()
            _rm()


    _rm = ->
        document.title = _title
        setTimeout ->
            elem.remove()
            elem.trigger('rmed')
            doc.unbind(keyup)
            scrollbar.destroy()


    rm_btn = elem.find('.I-'+option.ico).click rm

    elem0 = elem[0]
    elem0._rm = _rm
    elem.rm = rm

    doc.bind(
        keyup
        (e)->
            tagName = e.target.tagName
            option.keyup(e.keyCode, tagName)
            return
    )
    ing = undefined
    elem.option = option
    return elem
