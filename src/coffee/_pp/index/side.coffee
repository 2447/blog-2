module.exports = (html, slide)->
    html.append(
        """<style>.slideout-menu .menu-add{font-size:32px;color:#999;margin-top:64px;display:inline-block;cursor:pointer;}.slideout-menu .menu-add:hover{color:#f40;}</style><i class="I I-add menu-add"></i>"""
    )
    html.find('.menu-add').click ->
        box = $.pbox(
            """<div class="VC2"><div class="VC1"><div class="TC"><div class="PageLoading I-loading"></div></div></div></div>"""
        )
        $.when(
            System.import("coffee/_site/edit/_load")
            System.import('coffee/_site/edit')
        ).done (
            (load, mod)=>
                load(
                    ''
                    (md, file)=>
                        mod(box, md, file, 'menu')
                )
                slide.close()
        )
        # System.import("coffee/_site/edit/menu/_box/page").then (box)->
        #     box().done (url)->
        #         GO.push "/edit/~/#{url}.md"
        return
