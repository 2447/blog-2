OOPS = 'OOPS'
bind = (e, old_val)->
    type = e[0].type
    if type == "checkbox"
        event = "change"
    else
        event = "keyup"
    e.bind(
        event+".err"
        ->
            if @value != old_val[@name]
                $(@).unbind("#{event}.err").parents('.'+OOPS).removeClass(OOPS)
    )

$.err = (form, err)->
    count = 0
    form.find('.P.'+OOPS).removeClass(OOPS)
    form.find('.ERR').remove()

    old_val = {}
    for k,v of err
        if v
            count += 1
            e = form.find("[name=#{k}]")
            if not e[0]
                e = form.find("."+k)
            tip = e.parents('.P')
            tip.addClass(OOPS)
            tip.append("<div class=ERR>#{v}</div>")

            old_val[k] = e.val()
            bind e, old_val

                #     t.bind(
                #         "#{event}.errtip"
                #         ->
                #             _tiper = @_tiper
                #             if _tiper
                #                 if @value != _tiper.value
                #                     _tiper.reset()
                #                     for i,_pos in kv
                #                         if i == _tiper
                #                             kv.splice(_pos,1)
                #                             break
                #                     $(@).unbind("#{event}.errtip")
                #                     delete @_tiper
                #     )


    if count
        for i in form.find('.OOPS')
            input = $(i).find('input')
            if input[0]
                input.focus().select()
                break

    return count



