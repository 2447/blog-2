module.exports = (link, show)->
    defer = $.Deferred()
    if link
        okBtn = "设置"
    else
        okBtn = "新建"
    box = $.box.prompt(
        """<div class="Form"><h1>#{okBtn}页面</h1><div class="P"><div style="position:absolute;margin-left:20px;font-size:18px;line-height:74px;font-weight:bold;">/~</div><input style="padding-left:37px" name="url" placeholder=" 页面网址，限英文、数字、减号、斜杠"></div><div class="P SELECT"><label for=dirSelect>是否展示</label><select name="show" id=dirSelect><option value="0">不展示到首页菜单</option><option value="1">展示到首页菜单</option></select></div></div>"""
        {
            okBtn
            ok:->
                false
        }
    )
    box.find('form').save(
        "menu"
    ).then (o, [url, md])->
        box.close()
        defer.resolve url, md
    return defer

