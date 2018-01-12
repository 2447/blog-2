module.exports = (file, edit)->
    PP.json(
        "post/edit/"+(file or '')
        ({md, file, tmp})->
            if tmp
                $.box.confirm(
                    """<h1 class=TC><p>有未发布的改动</p><p>是否加载 ？</p></h1>"""
                    {
                        okBtn:"加载改动"
                        cancelBtn:"否"
                        ok:->
                            edit(tmp, file)
                        cancel:->
                            edit(md, file)
                    }
                )
            else
                edit(md, file)
            return
    )
