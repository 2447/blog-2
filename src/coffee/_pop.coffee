renderMd = (url, prefix)->
    PP.get(
        "-/md/"+url+".md"
        (md)=>
            [title, html] = require('coffee/_lib/load_md')(md)
            if PP.open
                edit = $(
                    """<a href="/edit/#{url}.md" class="I I-edit PboxIco" style="font-size:24px;bottom:11px;right:8px;top:auto;"></a>"""
                ).click =>
                    @[0]._rm()
                    return
                @append edit

            @find('.PboxMain').replaceWith """<div class=TXT><h1>#{$.escape(title or "无题")}</h1>#{html}</div>"""

            $.doc_title (prefix or '') + @find('h1:first').text()
    )

MAP = {
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
                load(
                    file
                    (md, file)=>
                        mod(@, md, file)
                        history.replaceState(null,null, "/edit/"+file)
                        defer.resolve()
                ).catch defer.reject()
        )
        return defer

    "-":(file)->
        if file.slice(0,2) != "S/"
            renderMd.call(
                @
                file
            )
        return
    help:(file)->
        renderMd.call(
            @
            "!/help/#{file or 'index'}"
            '帮助 - '
        )
    ...  require("./plugin.coffee")
}



_md = (link)->
    MAP[link] = ->
        renderMd.call(
            @
            "!/"+link
        )

do ->
    for i in "about link".split(' ')
        _md i

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
