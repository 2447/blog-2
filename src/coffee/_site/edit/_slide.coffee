slideout = require 'coffee/_lib/slideout'
slide = undefined

module.exports = (func)=>
    (option)->
        {ico} = option
        btn = $ @
        box = option.box
        close_btn = box.find('.PboxIco.I-close')
        if slide
            is_me = (slide.id == ico)
            slide.close()
            if is_me
                return
        box.on(
            'rmed'
            ->
                slide = undefined
        )
        ibtn = $(@parentNode).find('.I').removeClass('now').one('click.slide', ->
            if slide
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
                        box
                        html
                        'Right'
                        ->
                            btn.addClass 'now'
                            close_btn.stop().fadeOut()
                            setTimeout =>
                                if slide
                                    slide.close()
                                slide = option.slide
                        close
                    )
                    option.slide.id = ico
            option
        )
