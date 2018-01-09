
class Slideout
    constructor:(@box, @html, @side, @beforeOpen, @beforeClose)->
        @opened = 0
        @open()
    open : ->
        if @opened
            return
        slide_open = 'slideoutOpen'
        slideout_panel = 'slideout-panel'

        HTML = $ 'html'
        HTML.addClass slide_open

        @opened = 1
        @beforeOpen?()
        side = @side
        style= ' style="animation-duration:.2s"'
        slide = $ """<div class="slideout-menu slideout#{side} animated fadeIn"#{style}><i class="animated fadeIn I I-close PboxIco"></i><div#{style} class="slideout animated slideIn#{side}"></div></div>"""

        @box.addClass(slideout_panel).append slide
        out = slide.find('.slideout')
        out.html @html

        scrollbar = $.scrollbar(out[0])
        @close = ->
            if @opened == 2
                return
            @opened = 2
            @beforeClose?()
            out.removeClass "slideIn#{side}"
            out.addClass "slideOut#{side}"
            slide.addClass 'fadeOut'
            scrollbar.destroy()
            setTimeout(
                =>
                    @box.removeClass slideout_panel
                    @opened = undefined
                    HTML.removeClass slide_open
                    slide.remove()
                200
            )
        slide.find('.I-close').click =>
            @close()
        slide.click (e)=>
            if slide[0] == e.target
                @close()
    close:->

module.exports = ->
    new Slideout(...arguments)
