marked = require('coffee/_lib/marked')

renderMd = (url, prefix)->
    PP.get(
        "-/md/"+url+".md"
        (md)=>
            @find('.PboxMain').replaceWith """<div class=TXT>#{marked(md)}</div>"""
            if PP.open
                edit = $(
                    """<a href="/edit/#{url}.md" class="I I-edit PboxIco" style="font-size:24px;bottom:11px;right:8px;top:auto;"></a>"""
                ).click =>
                    @[0]._rm()
                    return
                @append edit

            $.doc_title (prefix or '') + @find('h1:first').text()
    )

MAP = {
    edit : (file)->
        if $(".EDIT.Pbox")[0]
            return
        p = PP.json("post/edit/#{file or ''}")
        $.when(
            p
            System.import('coffee/_site/edit')
        ).done (
            ([md], mod)=>
                {md, file, tmp} = md
                edit = =>
                    mod(@, md, file)
                    history.replaceState(null,null, "/edit/"+file)
                if tmp
                    $.box.confirm(
                        """<h1 class=TC><p>有未保存更改</p><p>是否恢复？</p></h1>"""
                        {
                            okBtn:"恢复"
                            cancelBtn:"否"
                            ok:->
                                edit()
                            cancel:->
                                md = tmp
                                edit()
                        }
                    )
                else
                    edit()
                return
        )
    "-":(file)->
        renderMd.call(
            @
            file
        )

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
            GO.push GO.currentRoute
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
