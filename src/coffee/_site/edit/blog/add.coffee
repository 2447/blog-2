module.exports = ({file, editor, h1})->
    System.import("coffee/_site/edit/_box/save").then (
        save
    ) ->
        html = editor.getContent()
        title = $.trim h1.val()
        if file.slice(0,8) != "!/draft/" or title or html.replace(/<[^>]+>/g,"").replace(/[\s\n\r\t]|&nbsp;/g,'')
            save(
                file
                title
                html
            ).then ->
                PP.get(
                    # 必须这样写，后台才能拿到参数
                    "post/edit//"
                    (file)->
                        editor.load_md(file, '')
                )
        else
            editor.setContent '<p><br></p>'
            h1.val('').focus()
