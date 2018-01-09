class TOAST
    constructor:->
        @_li = []
        @_offset = 0

    new : (msg, option={})->
        {timeout, body, close} = {
            timeout:5
            body:$('body')
            close:0
            ...option
        }
        if close
            _ = $.html()
            _ msg
            _ "<i "
            if typeof(close)=='string'
                _ """title="#{close}" """
            _ """class="I-close I"></i>"""
            msg = _.html()

        li = @_li
        elem = $ """<div class="animated bounceInRight toast" style="margin-bottom:#{@_offset}px;">#{msg}</div>"""
        li.push elem
        body.append(
            elem
        )
        @_offset += (18+elem.height())
        elem.close = =>
            elem.addClass "bounceOutRight"
            setTimeout(
                =>
                    li.splice li.indexOf(elem), 1
                    offset = 0
                    for i,pos in li
                        i.css "margin-bottom": offset
                        offset += (18+i.height())
                    @_offset = offset
                    elem.remove()
                500
            )
        if close
            elem.find('.I-close').click elem.close
        if timeout
            setTimeout(
                elem.close
                timeout*1000
            )
        return elem

TOAST = new TOAST()

$.toast = ->
    TOAST.new.apply TOAST, arguments
