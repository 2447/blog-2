ACTION = {
    add:->
        System.import("./_box/dir").then (mod)=>
            mod().done (dir, name)=>
                @val name
                @[0].dataset.v =  dir
        return ['', '']
    draft:(elem)->
        return elem.text()+" "
}

module.exports = System.import("./_slide").then (slideout)->
    slideout (resolve, {file, editor, h1, box})->
        html = $ require('./fly.slm')
        require("coffee/_lib/select")(
            html.find('input.select')
            ->
                defer = $.Deferred()
                PP.get(
                    "post/dir"
                    (txt)->
                        _ = $.html()
                        t = """<div class="li v" data-v="!/%en">%cn<i class="I I-%en"></i></div>"""
                        _ t.render({cn:'草稿箱',en:"draft"})
                        if txt
                            for i in txt.split("\n")
                                [dir, name] = i.split("\r")
                                _ """<div class=li><b class="v" data-v="#{$.escape dir}">#{$.escape name}</b><i class="I I-edit IBtn"></i></div>"""
                        _ t.render({cn:'新建章节',en:"add"})
                        defer.resolve _.html()
                )

                return defer
            (input)->
                v = @data('v')+''
                [s,cls] = v.split('/')
                if s != "!"
                    return
                if cls of ACTION
                    return ACTION[cls].call input, @
            (input)->
                @find('.I-edit').click ->
                    b = @previousSibling
                    v = b.dataset.v
                    input0 = input[0]
                    System.import("./_box/dir").then (mod)=>
                        mod(
                            b.innerText
                            b.dataset.v
                        ).then (dir, name)=>
                            if input0.dataset.v == b.dataset.v
                                input0.dataset.v = dir
                                input.val(name)
                            if dir
                                b.dataset.v = dir
                                b.innerText = name
                            else
                                $(@).closest('.li').remove()

        )
        html.find('input.btn').click ->
            System.import("./save.coffee").then(
                (mod)->
                    mod(
                        file
                        h1.val()
                        editor.getContent()
                    ).done (url)->
                        box._rm()
                        GO.push url
            )
        resolve html
