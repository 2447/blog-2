br = '<br>'
UPLOAD_INSERT = {
    file: """<p><a target="_blank" href="%url">%name</a></p>"""
    photo: """<p><img src="%url" alt="%name"></p>"""
}

editor_box = (UPLOAD_CN, EDITOR_ADD_BAR, editor, page, action, files=[])->
    cn = UPLOAD_CN[action]
    input = undefined
    guid = ++ $.guid
    args = arguments
    ed = $(editor.elements)
    place = ed.find(".medium-insert-active")
    focus = ->
        editor.selectElement(place[0])
    _ = $.html()

    box = $.box.confirm(
        """<div class="medium-box-upload"><h1>#{EDITOR_ADD_BAR}</h1><div><label class="C" for="medium-box-upload#{guid}"><div>点此上传#{cn}<br>按住CTRL键可多选</div></label><input id="medium-box-upload#{guid}" type="file" multiple></div><div class="ol"></div></div>"""
        cancel: focus
        ok:->
            focus()
            if not files.length
                return
            ins = UPLOAD_INSERT[action]
            up = (pos)->
                img = $ """<img class="I-loading">"""
                if pos
                    place.after img
                else
                    place.before img

                System.import('coffee/_lib/upload').then (upload)->
                    upload.post(
                        files[pos]
                        PP.URL
                        (file, url)->
                            place = $(ins.render {
                                name:$.escape(file.name)
                                url:PP.F+"S/"+$.escape(url)
                            })
                            img.replaceWith place
                            if (++pos) < files.length
                                up(pos)
                            return
                        page
                    )
            up(0)
            return
    )
    box.find(".fa-#{action}").addClass 'now'
    box.find('.fa').click ->
        key = /fa-([^\s]+)/.exec(@className)[1]
        if key != action
            box.close()
            args = [...args]
            args[4] = key
            if args >= 5
                args[5] = files
            else
                args.push files
            editor_box.apply(
                @
                args
            )

    input = box.find('input[type=file]')
    file_li = ->
        _ = $.html()
        if files.length
            _ """<ol>"""
            for i in files
                _ """<li>#{$.escape i.name}<b class="size">#{require("coffee/_lib/upload/size") i.size}</b></li>"""
            _ """</ol>"""
        box.find('.ol').html _.html()

    input.change ->
        files = @files
        file_li()
    file_li()

module.exports = editor_box
