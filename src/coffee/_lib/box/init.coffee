# https://github.com/claviska/jquery-alertable/

_alert = (html, option)->
    option = {
        ... {
            okBtn:'确定'
            cancelBtn:'取消'
        }
        ... option
    }
    btn = option.btn
    if btn
        btn = btn.render(option)
    else
        btn = """<input type="submit" class="btn ok" value="#{option.okBtn}">"""
    if not $('._BoxBg')[0]
        body.append(
            """<div class="_BoxBg"></div>"""
        )

    modal = $ require('./init.slm')
    modal.find('form').submit(
        ->
            r = option.ok?()
            if r == false
                return r
            modal.close()
            return false
    ).html """<div class=html></div>#{btn}"""
    modal.find('.html').html html
    modal.close = ->
        modal.trigger('close')
        modal.remove()
        if not $('._Box').length
            $('._BoxBg').remove()

    body.append modal
    modal.on(
        'click'
        'a'
        ->
            modal.fadeOut ->
                modal.close()
            return
    )
    return modal

body = $ 'body'


$.box = {
    err : (html, option)->
        _alert """<h1 style="font-weight:bold;color:red">出错了！</h1><h1>#{html}</h1>""", option

    alert:(html, option)->
        if html.indexOf("<") < 0
            html = """<h1>#{html}</h1>"""
        _alert html , option

    prompt:(html, option)->
       _box = $.box.confirm html, option
       autocomplete = 'autocomplete'
       for i in _box.find('input')
           if not i.autocomplete
               i.autocomplete = 'off'
       return _box

    confirm:(html, option)->
        box = _alert html, {
            btn:"""<div class="boxConfirm"><button class="btn ok" type="submit"><span>%okBtn</span></button><button type="reset" class="btn cancel"><span>%cancelBtn</span></button></div>"""
            ...option
        }
        box.find('button[type=reset]').click ->
            option.cancel?()
            box.close()
            return false
        box
}

