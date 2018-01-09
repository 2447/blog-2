slideout = require 'coffee/_lib/slideout'
slide = undefined

module.exports = (func)=>
    (option)->
        {ico} = option
        btn = $ @
        pbox = btn.parents('.Pbox')
        close_btn = pbox.find('.PboxIco.I-close')
        option.box = pbox[0]
        if slide
            is_me = (slide.id == ico)
            slide.close()
            if is_me
                return



        ibtn = $(@parentNode).find('.I').removeClass('now').one('click.slide', ->
            if not $(@).hasClass "I-"+slide.id
                slide.close()
            return
        )
        close = ->
            slide = undefined
            ibtn.unbind 'click.slide'
            btn.removeClass 'now'
            close_btn.fadeIn()
            option.editor.autofocus()
        func(
            (html)->
                if html
                    option.slide = slideout(
                        pbox
                        html
                        'Right'
                        ->
                            btn.addClass 'now'
                            close_btn.stop().fadeOut()
                            setTimeout =>
                                slide = option.slide
                        close
                    )
                    option.slide.id = ico

            option
        )
