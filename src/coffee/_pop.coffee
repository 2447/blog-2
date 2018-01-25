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
                if file and file.charAt(0) == "!"
                    bar = 'menu'
                else
                    bar = 'blog'
                load(
                    file
                    (md, file)=>
                        mod(@, md, file, bar)
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
    ...  require("./plugin.coffee")
}





split_n = require('coffee/_lib/split_n')

Z_INDEX = 100

GO.beforeEach (to, from, next)=>
    path = to.path
    for i in $(".Pbox")
        if path == i.dataset.path
            box = $(i)
            box.css "z-index", ++Z_INDEX
            return

    if path.slice(0,2) == '/!'
        func = (url)->
            System.import(
                "coffee/_pop/_md"
            ).then (render)=>
                render.call(
                    @
                    "!"+path.slice(2)
                )
            return
    else
        [prefix, suffix] = split_n(path.slice(1),"/",2)
        func = MAP[prefix]
    if func
        box = $.pbox(
            """<div class="VC2"><div class="VC1"><div class="TC"><div class="PageLoading I-loading"></div></div></div></div>"""
        )
        box.attr('data-path', path)

        _path = location.pathname
        if _path == path
            _path = '/'

        setPath =->
            if location.pathname == _path and _path != path
                history.pushState(null, null, path)


        popstate = "popstate.pbox"+(++$.guid)
        win = $(window).bind(
            popstate
            ->
                lpath = location.pathname
                box_rm = ->
                    box[0]._rm()
                    return
                sign = lpath.slice(1).split("/")[0]
                if not (sign.charAt(0) == "!" or sign of MAP) or (location.pathname == _path and _path != path)
                    box_rm()
                return
        )

        box.on 'rm', ->
            lpath = location.pathname
            if lpath == path # 没后退
                lpath = _path
                history.pushState(null, null,lpath)

            GO.reload()
            return
        box.on 'rmed', ->
            win.unbind popstate

        r = func.call(box, suffix)
        if r and r.catch
            r.done(
                setPath
            ).catch(
                ->
                    box[0].rm()
            )
        else
            setPath()
    else
        next()
