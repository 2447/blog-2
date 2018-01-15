EN = "draft".split(' ')
EN_LEN = EN.length
OPEN = 'open'
NOW = 'now'
Sortable = require "sortablejs/Sortable.js"

module.exports = System.import("coffee/_site/edit/_slide").then (slideout)->
    slideout (resolve, option)->
        {file, editor} = option
        render = (en, li)->

            _ = $.html()
            _ """<ul class="UL-#{en}">"""
            if li.length
                for [p, title] in li
                    p = $.escape en+"/"+p
                    _ """<li title="#{p}"><div class="R"><i class="I I-trash"></i><i class="I I-edit"></i></div><h2>#{$.escape title}</h2></li>"""
            else
                _ """<li style="text-align:center;color:#999">暂无</li>"""
            _ "</ul>"
            h = $ _.html()
            h.find('.I-trash').click ->
                me = $ @
                li = me.parents('li')
                filepath = li[0].title
                if filepath == file
                    System.import(
                        "./add.coffee"
                    ).then (mod)->
                        mod(option)
                $.box.confirm(
                    """<h1 class=TC><p><a title="#{filepath}" href="/edit/#{filepath}">#{li.find('h2').html()}</a></p><p>确认删除？</p></h1>"""
                    {
                        okBtn:"删除"
                        ok:  ->
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
            h.find('.I-edit').click ->
                p = @parentNode.parentNode.title
                System.import("coffee/_site/edit/_load").then(
                    (load)->
                        load(
                            p
                            (md)->
                                editor.load_md p, md
                                option.slide.close()
                                history.replaceState(null,null, "/edit/"+p)
                        )
                )
            return h

        PP.json(
            'post'
            (li_li)->
                name_li = li_li.shift()
                en_li = li_li.shift()
                _ = $.html()
                html = $ require('./post.slm')
                html.append _.html()
                tab = html.find('.tab a').click ->
                    tab.removeClass NOW
                    self = $(@)
                    self.addClass NOW
                    rel = @rel
                    pos = EN.indexOf(rel)
                    if pos + 1
                        h = render("!/"+rel, li_li[pos])
                    else
                        _ = $.html()
                        _ "<div>"
                        for name, pos in name_li
                            _ """<div data-v="#{en_li[pos]}" title="#{li_li[pos+EN_LEN].length} 篇文章" class="dir dir#{pos}"><b>#{$.escape name}</b><i class="I"></i></div>"""
                        _ "</div>"
                        h = $ _.html()
                        new Sortable(
                            h[0]
                            {
                                draggable:".dir"
                                onStart:->
                                    h.find('.dir').removeClass 'open'
                                    h.find('ul').remove()
                                    return
                                onEnd:->
                                    PP.postJSON(
                                        "post/sort/dir"
                                        (i.dataset.v for i in h.find('.dir'))
                                    )
                                    return
                            }
                        )
                        h.find('.dir').dblclick (e)->
                            if 'I' == e.target.tagName
                                return
                            me = $ @
                            b = me.find('b')
                            System.import("coffee/_site/edit/blog/_box/dir").then (box_dir)->
                                box_dir(
                                    b.text()
                                    me.data('v')
                                ).then (dir, name)->
                                    if dir
                                        me.data('v', dir)
                                        b.text name
                                    else
                                        me.remove()

                        h.find('.dir I').click ->
                            p = @parentNode
                            me = $ p
                            if me.hasClass OPEN
                                me.removeClass(OPEN).next('ul').remove()
                            else
                                pos = p.className.split(' ').pop().slice(3) - 0
                                en = en_li[pos]
                                md_pos = pos+EN_LEN
                                md_li = li_li[md_pos]
                                po_li = render(en, md_li)
                                new Sortable(
                                    po_li[0]
                                    onEnd:->
                                        offset = en.length+1
                                        md_dict = {}
                                        for [md_en, md_cn] in md_li
                                            md_dict[md_en] = md_cn

                                        title_en = []
                                        md_li = []
                                        for i in po_li.find('li')
                                            md_en = i.title.slice(offset)
                                            title_en.push md_en
                                            md_li.push [md_en, md_dict[md_en]]
                                        li_li[md_pos] = md_li

                                        PP.postJSON(
                                            "post/sort/li"
                                            [en].concat title_en
                                        )
                                        return
                                )
                                me.addClass(OPEN).after po_li

                    html.find('.W').html h

                file_dir = file.split("/")
                if file_dir[0] == "!"
                    file_pos = EN.indexOf(file_dir[1])+1
                else
                    file_pos = 0
                tab[file_pos].click()
                if not file_pos
                    file_pos = en_li.indexOf(file_dir[0])
                    if not file_pos and en_li.length
                        file_pos = 0
                    if file_pos + 1
                        html.find('.dir I')[file_pos].click()

                # html.find('.dir').click ->
                # html.find(".dir"+).click()


                resolve html
        )
