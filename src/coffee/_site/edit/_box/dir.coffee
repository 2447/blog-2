module.exports = (name, dir, defer)->
    if not defer
        defer = $.Deferred()
    if name and dir
        title = "章节命名"
        success = "设定"
    else
        title = "新建章节"
        success = "创建"
    if dir
        dir = dir+""
    # data-en 可能type是数字 ， 囧
    box = $.box.confirm(
        """<div class=Form><style>._Box h1 .I-trash{font-size:24px;float:right;width: 24px;height:57px;text-align:center;line-height:57px;cursor:pointer;}._Box h1 .I-trash:hover{color:#f40;}</style><h1>#{title}<i class="I I-trash"></i></h1><div class=P><input placeholder="章节名称" value="#{if name then $.escape name else ''}" name="name" autocomplete=off></div><div class=P><input autocomplete=off name="dir" value="#{if dir then $.escape(dir) else ''}" placeholder="网址前缀，如 tech 、2018 等；限英文、数字、减号"></div></div>"""
        {
            okBtn:"创建"
            ok:->
                false
        }
    )
    trash = box.find('.I-trash')
    if dir
        trash.click ->
            box.close()
            $.box.confirm(
                """<h1>确认删除 章节 『#{$.escape name}』( #{$.escape dir} ) ?</h1>"""
                {
                    ok:->
                    cancel:->
                        setTimeout ->
                            module.exports(name, dir, defer)
                        return
                }

            )
    else
        trash.remove()

    box.find('form').save(
        "post/dir"
        {
            old:dir
        }
    ).then ({dir, name})->
        box.close()
        $.box.alert """章节『#{$.escape name}』(#{dir}) #{success}成功！"""
        defer.resolve(
            dir
            name
        )
    return defer
