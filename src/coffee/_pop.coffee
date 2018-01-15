module.exports = MAP = {
    edit : (file)->
        @option.keyup = ->
        if $(".EDIT.Pbox")[0]
            return
        defer = $.Deferred()
        $.when(
            System.import("coffee/_site/edit/_load")
            System.import('coffee/_site/edit')
        ).done (
            (load, mod)=>
                if file and file.slice(0,2) == "!/"
                    bar = 'link'
                else
                    bar = 'blog'
                load(
                    file
                    (md, file)=>
                        mod(@, md, file, bar)
                        history.replaceState(null,null, "/edit/"+file)
                        defer.resolve()
                ).catch defer.reject
        )
        return defer

    "-":(file)->
        if file.slice(0,2) != "S/"
            System.import(
                "coffee/_pop/_md"
            ).then (render)=>
                render.call(
                    @
                    file
                )
        return
    # help:(file)->
    #     renderMd.call(
    #         @
    #         "!/help/#{file or 'index'}"
    #         '帮助 - '
    #     )
    ...  require("./plugin.coffee")
}





split_n = require('coffee/_lib/split_n')

GO.beforeEach (to, from, next)=>
    path = to.path
    [prefix, suffix] = split_n(path.slice(1),"/",2)
    func = MAP[prefix]
    if func
        box = $.pbox(
            """<div class="VC2"><div class="VC1"><div class="TC"><div class="PageLoading I-loading"></div></div></div></div>"""
        )
        _path = location.pathname
        setPath =->
            if location.pathname == _path and _path != path
                history.pushState(null, null, path)

        box.on 'rm', ->
            GO.reload()
            return

        r = func.call(box, suffix)
        if r and r.catch
            r.done(
                setPath
            ).catch(
                ->
                    box.rm()
            )
        else
            setPath()
    else
        next()
