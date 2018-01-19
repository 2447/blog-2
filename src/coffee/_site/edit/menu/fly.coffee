module.exports = System.import("coffee/_site/edit/_slide").then (slideout)->
    slide = slideout (resolve, {file, editor, h1, box})->
        html = $ require('./fly.slm')

        render = (select, val)->
            html.find(
                "input[name=url]"
            ).val val
            html.find('select[name=show]').change(
                ->
                    val = @value - 0
                    if val < 0
                        action = 'hide'
                    else
                        action = 'show'
                    p = html.find('.P.show')[action]()
                    p.find('input').focus()
            ).val(select).change()
            html.save(
                "menu"
                {
                    old:file
                }
                ->
                    defer = $.Deferred()
                    System.import("coffee/_site/edit/save.coffee").then(
                        (mod)->
                            mod(
                                file
                                h1.val()
                                editor.getContent()
                            ).done ->
                                defer.resolve()
                    )
                    defer

            ).then (o, [url])->
                box[0]._rm()
                if not url.startsWith("$/")
                    url = "!"+url
                else
                    url = "-/"+url
                GO.push url
            resolve html

        if file.startsWith("!/")
            PP.get( "menu/show/"+file.slice(2)).then (s)->
                render s, file.slice(2,-3)
        else
            render -1, ''
    return slide
        # System.import("coffee/_site/edit/save.coffee").then(
        #     (mod)->
        #         mod(
        #             file
        #             title
        #             editor.getContent()
        #             {dir:"!"}
        #         ).done (url)->
        #             box._rm()
        #             $.box.alert "『#{$.escape(title or '无题')}』保存成功"
        #             if url
        #                 url = file.slice(2,-3)
        #                 GO.push "/!"+url
        #             return
        # )
