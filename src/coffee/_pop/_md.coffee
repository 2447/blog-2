
win = $ window
module.exports = (url, prefix)->
    PP.get(
        "-/"+url+".md"
        (md)=>
            [title, html] = require('coffee/_lib/load_md')(md)
            if PP.open
                System.import(
                    "coffee/_pp/post/edit"
                ).then(
                    (mod)=>
                        mod(
                            url
                            @
                            =>
                                @[0]._rm()
                        )
                )
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
                    if txt.height() - top > min_height
                        macs.update()
                        return
                    elem = html.shift()
                    for i in $(elem).find('img')
                        i.src = i.dataset.src
                        delete i.dataset.src
                    txt.append(elem)
                macs.update()
                unbind()
                return

            unbind = ->
                macs.unbind scroll_name
                win.unbind resize_name

            resize_name = "resize."+guid
            win.bind(
                resize_name
                ->
                    scroll.apply macs
                    update_min_height()
            )

            @on('rm', unbind)

            macs = @find('.macS')[0].scrollbar
            macs.bind(scroll_name, scroll)

            scroll.apply macs

            $.doc_title (prefix or '') + @find('h1:first').text()
    )
