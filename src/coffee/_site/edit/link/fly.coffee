module.exports = ({h1, file, editor, box})->
    title = h1.val()
    box = $(@).closest('.Pbox')[0]
    System.import("coffee/_site/edit/save.coffee").then(
        (mod)->
            mod(
                file
                title
                editor.getContent()
                {dir:"!"}
            ).done (url)->
                box._rm()
                $.box.alert "『#{$.escape(title or '无题')}』保存成功"
                if url
                    url = file.slice(2,-3)
                    GO.push "/"+url
                return
    )
    return
