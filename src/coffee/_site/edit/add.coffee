module.exports = ({file, editor, h1})->
    System.import("./_box/save").then (
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
                console.log 'add'
                PP.get(
                    "post/edit//"
                    (file)->
                        editor.load_md(file, "")
                        history.replaceState(null,null, "/edit/"+file)
                )
        else
            editor.setContent '<p><br></p>'
            h1.val('').focus()
