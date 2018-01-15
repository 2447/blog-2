module.exports = (link, show)->
    defer = $.Deferred()
    if link
        okBtn = "设置"
    else
        okBtn = "新建"
    $.box.prompt(
        """<div class="Form"><h1>#{okBtn}页面</h1><div class="P"><input placeholder="链接网址，限英文、数字、减号、斜杠"></div><div class="P SELECT"><label for=dirSelect>是否展示</label><select name="sort" id=dirSelect><option value="0">不展示到首页菜单</option><option value="1">展示到首页菜单</option></select></div></div>"""
        {
            okBtn
            ok:->
                false
        }
    )
    return defer

