EN = "$".split(' ')
EN_LEN = EN.length
OPEN = 'open'
NOW = 'now'
Sortable = require "sortablejs/Sortable.js"

module.exports = System.import("coffee/_site/edit/_slide").then (slideout)->
    slideout (resolve, option)->
        {box, file, editor} = option
        render = (en, li, pos)->

            _ = $.html()
            _ """<ul class="UL-#{pos}">"""
            if li.length
                for [p, title] in li
                    p = $.escape en+"/"+p
                    _ """<li title="#{p}"><div class="R"><i class="I I-trash"></i><i class="I I-edit"></i></div><h2 class="h2">#{$.escape(title or '')}</h2></li>"""
            else
                _ """<li style="text-align:center;color:#999">暂无</li>"""
            _ "</ul>"
            h = $ _.html()
            h.find('.I-trash').click ->
                me = $ @
                li = me.parents('li')
                filepath = li[0].title
                $.box.confirm(
                    """<h1 class=TC><p><a title="#{filepath}" href="/edit/#{filepath}">#{li.find('h2').html()}</a></p><p>确认删除？</p></h1>"""
                    {
                        okBtn:"删除"
                        ok:  ->
                            if filepath == file
                                System.import(
                                    "../blog/add.coffee"
                                ).then (mod)->
                                    mod(option)
                            PP.postJSON1(
                                "post/rm/"+filepath
                                ->
                                    li.slideUp(->
                                        li.remove()
                                    )
                            )
                    }
                )
                return
            require("../post_a_edit")(editor,option,h)

            return h
        PP.json(
            "menu"
            (li)->
                tab_n = 1
                t = []
                _file = file.slice(2)
                if li[0]
                    for i in li[0].split("\n")
                        _ = require('coffee/_lib/split_n')(i,' ',2)
                        if _[0] == _file
                            tab_n = 0
                        t.push _
                else
                    li[0] = []
                if file.startsWith("$/")
                    tab_n = 2
                li[0] = t

                t = []
                if li[1]
                    for i, pos in li[1].split("\n")
                        t.push [i,"~/"+i.slice(0,-3)]
                else
                    li[1] = []

                li[1] = t

                html = $ require('./post.slm')

                tab = html.find('.tab a').click ->
                    tab.removeClass NOW
                    self = $(@)
                    self.addClass NOW
                    rel = @rel
                    for i, pos in tab
                        if i == @
                            if pos == 2
                                sign = "$"
                            else
                                sign = "~"
                            break
                    h = render(sign, li[pos], pos)
                    html.find('.W').html h
                    if pos
                        h.find('h2').click ->
                            $(@).closest('li').find('.I-edit').click()
                    else
                        new Sortable(
                             h[0]
                             {
                                 onEnd:->
                                     r = []
                                     for i in h.find('li')
                                         r.push i.title.slice(2)
                                     PP.postJSON(
                                         "post/sort/li"
                                         ["~"].concat r
                                     )
                                     return
                             }
                         )
                    return
                tab[tab_n].click()
                resolve html
        )
        # PP.json(
        #     'post'
        #     (li_li)->
        #         name_li = li_li.shift()
        #         en_li = li_li.shift()
        #         _ = $.html()
        #         html = $ require('./post.slm')
        #         html.append _.html()
        #         tab = html.find('.tab a').click ->
        #             tab.removeClass NOW
        #             self = $(@)
        #             self.addClass NOW
        #             rel = @rel
        #             pos = EN.indexOf(rel)
        #             if pos + 1
        #                 h = render(rel+"/", li_li[pos])
        #             else
        #                 _ = $.html()
        #                 _ "<div>"
        #                 for name, pos in name_li
        #                     _ """<div data-v="#{en_li[pos]}" title="#{li_li[pos+EN_LEN].length} 篇文章" class="dir dir#{pos}"><b>#{$.escape name}</b><i class="I"></i></div>"""
        #                 _ "</div>"
        #                 h = $ _.html()
        #                 new Sortable(
        #                     h[0]
        #                     {
        #                         draggable:".dir"
        #                         onStart:->
        #                             h.find('.dir').removeClass 'open'
        #                             h.find('ul').remove()
        #                             return
        #                         onEnd:->
        #                             PP.postJSON(
        #                                 "post/sort/dir"
        #                                 (i.dataset.v for i in h.find('.dir'))
        #                             )
        #                             return
        #                     }
        #                 )
        #                 h.find('.dir').dblclick (e)->
        #                     if 'I' == e.target.tagName
        #                         return
        #                     me = $ @
        #                     b = me.find('b')
        #                     System.import("coffee/_site/edit/blog/_box/dir").then (box_dir)->
        #                         box_dir(
        #                             b.text()
        #                             me.data('v')
        #                         ).then (dir, name)->
        #                             if dir
        #                                 me.data('v', dir)
        #                                 b.text name
        #                             else
        #                                 me.remove()

        #                 h.find('.dir I').click ->
        #                     p = @parentNode
        #                     me = $ p
        #                     if me.hasClass OPEN
        #                         me.removeClass(OPEN).next('ul').remove()
        #                     else
        #                         pos = p.className.split(' ').pop().slice(3) - 0
        #                         en = en_li[pos]
        #                         md_pos = pos+EN_LEN
        #                         md_li = li_li[md_pos]
        #                         po_li = render(en, md_li)
        #                         new Sortable(
        #                             po_li[0]
        #                             onEnd:->
        #                                 offset = en.length+1
        #                                 md_dict = {}
        #                                 for [md_en, md_cn] in md_li
        #                                     md_dict[md_en] = md_cn

        #                                 title_en = []
        #                                 md_li = []
        #                                 for i in po_li.find('li')
        #                                     md_en = i.title.slice(offset)
        #                                     title_en.push md_en
        #                                     md_li.push [md_en, md_dict[md_en]]
        #                                 li_li[md_pos] = md_li

        #                                 PP.postJSON(
        #                                     "post/sort/li"
        #                                     [en].concat title_en
        #                                 )
        #                                 return
        #                         )
        #                         me.addClass(OPEN).after po_li

        #             html.find('.W').html h

        #         file_dir = file.split("/")
        #         if file_dir[0] == "~"
        #             file_pos = EN.indexOf(file_dir[1])+1
        #         else
        #             file_pos = 0
        #         tab[file_pos].click()
        #         if not file_pos
        #             file_pos = en_li.indexOf(file_dir[0])
        #             if not file_pos and en_li.length
        #                 file_pos = 0
        #             if file_pos + 1
        #                 html.find('.dir I')[file_pos].click()

        #         # html.find('.dir').click ->
        #         # html.find(".dir"+).click()


        #         resolve html
        # )
