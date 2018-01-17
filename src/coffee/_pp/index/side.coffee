module.exports = (html, slide)->
    html.append(
        """<style>.slideout-menu .menu-add{font-size:32px;color:#999;margin-top:64px;display:inline-block;cursor:pointer;}.slideout-menu .menu-add:hover{color:#f40;}</style><i class="I I-add menu-add"></i>"""
    )
    html.find('.menu-add').click ->
        System.import("coffee/_site/edit/link/_box/page").then (box)->
            box().done (url)->
                GO.push "/edit/~/#{url}.md"
                slide.close()
        return
