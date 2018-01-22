
win = $ window
module.exports = (url, prefix)->
    PP.get(
        "-/md/"+url+".md"
        (md)=>
            [title, html] = require('coffee/_lib/load_md')(md)
            if PP.open
                edit = $(
                    """<a href="/edit/#{url}.md" class="I I-edit PboxIco" style="font-size:24px;bottom:11px;right:8px;top:auto;"></a>"""
                ).click =>
                    @[0]._rm()
                    return
                @append edit

            txt = $ """<div class=TXT><h1>#{$.escape(title or "无题")}</h1></div>"""
            @find('.PboxMain').replaceWith txt

            html = html.replaceAll('<img src="', '<img src="data:image/gif;base64,R0lGODlhAQABAAD/ACwAAAAAAQABAAACADs=" data-src="')
            html = $(html).toArray()

            min_height = 0

            update_min_height = ->
                min_height = parseInt(win.height()*2+200)

            update_min_height()

            guid = ++ $.guid
            scroll_name = "scroll."+guid

            scroll = ->
                count = html.length
                top = @scrollTop
                while count--
                    if @scrollHeight - top > min_height
                        return
                    elem = html.shift()
                    for i in $(elem).find('img')
                        i.src = i.dataset.src
                        delete i.dataset.src
                    txt.append(elem)
                unbind()

            unbind = ->
                macs.unbind scroll_name
                win.unbind resize_name

            resize_name = "resize."+guid
            win.bind(
                resize_name
                ->
                    scroll.apply macs[0]
                    update_min_height()
            )

            @on('rm', unbind)

            macs = @find('.macS').bind(scroll_name, scroll)

            scroll.apply macs[0]

            $.doc_title (prefix or '') + @find('h1:first').text()
    )
