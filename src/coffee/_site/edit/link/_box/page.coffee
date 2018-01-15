module.exports = (link, show)->
    defer = $.Deferred()
    if link
        okBtn = "新建"
    else
        okBtn = "设置"
    $.box.prompt(
        """<div class="Form"><h1>#{okBtn}页面</h1><div class="P"><input placeholder="链接网址，限英文、数字、减号、斜杠"></div></div>"""
        {
            okBtn
            ok:->
                false
        }
    )
    return defer

