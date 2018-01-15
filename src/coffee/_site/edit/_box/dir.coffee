module.exports = (name, dir, defer)->
    if dir
        dir = dir+""
    if not defer
        defer = $.Deferred()
    if name and dir
        title = "章节设置"
        okBtn = "设定"
    else
        title = "新建章节"
        okBtn = "创建"
    # data-en 可能type是数字 ， 囧
    _pop = (sort)=>
        box = $.box.prompt(
            """<div class=Form><style>._Box h1 .I-trash{font-size:24px;float:right;width: 24px;height:57px;text-align:center;line-height:57px;cursor:pointer;}._Box h1 .I-trash:hover{color:#f40;}</style><h1>#{title}<i class="I I-trash"></i></h1><div class=P><input placeholder="章节名称" value="#{if name then $.escape name else ''}" name="name"></div><div class=P><input name="dir" value="#{if dir then $.escape(dir) else ''}" placeholder="网址前缀，如 tech 、2018 等；限英文、数字、减号"></div><div class="P SELECT"><label for=dirSelect>默认顺序</label><select name="sort" id=dirSelect><option value="-1">新文章在前</option><option value="1">新文章在后</option></select></div></div>"""
            {
                okBtn
                ok:->
                    false
            }
        )
        box.find('select[name=sort]').val sort
        trash = box.find('.I-trash')
        if dir
            trash.click ->
                box.close()
                url = "post/rm/"+dir
                PP.get1(
                    url
                    (len)->
                        repop = ->
                            setTimeout ->
                                module.exports(name, dir, defer)
                                return
                        tip = """章节『#{$.escape name}』(#{$.escape dir})"""
                        if len
                            $.box.alert(
                                """<h1><p>#{tip} 尚有 #{len} 篇文章。</p><p>删除所有文章后，才能删除章节。</p></h1>"""
                                ok : repop
                            )
                        else
                            $.box.confirm(
                                """<h1>确认删除 #{tip} ?</h1>"""
                                {
                                    ok:->
                                        PP.postJSON1(
                                            url
                                            ->
                                                defer.resolve('','')
                                        )
                                    cancel: repop
                                }

                            )
                )
        else
            trash.remove()

        box.find('form').save(
            "post/dir"
            {
                old:dir
            }
        ).then ({dir, name})->
            dir = dir.toLowerCase()
            box.close()
            $.box.alert """章节『#{$.escape name}』(#{dir}) #{okBtn}成功！"""
            defer.resolve(
                dir
                name
            )
    if dir
        PP.json(
            "post/dir/sort/"+dir
            (sort)->
                _pop(sort)

        )
    else
        _pop(1)
    return defer
