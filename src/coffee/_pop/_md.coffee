module.exports = (url, prefix)->
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
