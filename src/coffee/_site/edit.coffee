upload = require 'coffee/_lib/upload'

editor_box = (page, action)->
    guid = ++ $.guid
    input = undefined
    files = undefined

    box = $.box.confirm(
        """<div class="medium-box-upload"><div><label class="C" for="medium-box-upload#{guid}"><div class="FC2"><div class="FC1"><i class="fa fa-#{action}"></i><div>点此上传文件<br>按住SHIFT键可多选</div></label><input id="medium-box-upload#{guid}" type="file" multiple></div></div></div><div class="ol"></div></div>"""
        ok:->
            upload.post(
                SITE.URL
                files
                page
                (file, url)->
                    console.log file.name, url
            )
            false
    )
    input = box.find('input[type=file]')
    input.change ->
        _ = $.html()
        _ """<ol>"""
        files = @files
        for i in files
            _ """<li>#{$.escape i.name}<b class="size">#{upload.size i.size}</b></li>"""
        _ """</ol>"""
        box.find('.ol').html _.html()
    # require('coffee/_lib/upload')(
    #     (url)->
    #         console.log url
    #     page
    # )


EditorAdd = (page, editor)->
    cls_ins = '.medium-insert-buttons'
    cls_ins_ = cls_ins.slice(1)
    cls_open = "medium-insert-open"
    cls_active = ".medium-insert-active"
    br = '<br>'
    cls_active_ = cls_active.slice 1

    editor.on(
        'click'
        cls_active
        (e)->
            target = e.target
            el = $(target)
            close = (elem)=>
                elem.removeClass(cls_open)
                elem.html(br)

            if el.hasClass 'fa'
                close(el.parents('.'+cls_open))
                editor_box(page, target.className.split("-").pop())
                return
            else if e.offsetX >= 0
                return

            if el.hasClass cls_open
                close(el)
            else
                el.html("""<span class="medium-insert-bar"><i class="fa fa-photo"></i><i class="fa fa-upload"></i></span>"""+br)
                el.addClass(cls_open)
                editor.blur()


            return false

    ).on('keyup click', (e)->
        $el = $(e.target)
        selection = window.getSelection()
        that = this
        if not selection or selection.rangeCount == 0
            $current = $el
        else
            range = selection.getRangeAt(0)
            $current = $(range.commonAncestorContainer)
# When user clicks on  editor's placeholder in FF, $current el is editor itself, not the first paragraph as it should
        if $current.hasClass('medium-editor-insert-plugin')
            $current = $current.find('p:first')
        $p = if $current.is('p') then $current else $current.closest('p')
        editor.clean()
        if $current[0] == editor[0]
            return
        if not $el.hasClass('medium-editor-placeholder')
            turn = $p.length and ( !$p.text().trim() )
            li = editor.find(cls_active)
            if turn and $p.hasClass cls_active_ and li.length == 1
                return
            li.each(
                ->
                    if @ == $p[0] and turn
                        return
                    self = $ @
                    self.removeClass(cls_active_)
                    if self.hasClass(cls_open)
                        self.html br
                        self.removeClass(cls_open)
            )
            # TODO 高亮插件
            # $.each @options.addons, (addon) ->
            # if $el.closest('.medium-insert-' + addon).length
            #      $current = $el
            # if $current.closest('.medium-insert-' + addon).length
            #   $p = $current.closest('.medium-insert-' + addon)
            #   activeAddon = addon
            #   return
            # return
            if turn
                $p.addClass cls_active_
                # and !activeAddon or activeAddon == 'images'
                # moveCaret $p[0], 0
                # if activeAddon == 'images'
                      # editor.find('.medium-insert-buttons').attr 'data-active-addon', activeAddon
                #else
                      # editor.find('.medium-insert-buttons').removeAttr 'data-active-addon'
            # If buttons are displayed on addon paragraph, wait 100ms for possible captions to display
                  #positionButtons() #activeAddon
                  # @showButtons activeAddon
# else
# @hideButtons()
        return
    )
    editor.on(
        "selectstart mousedown"
        ".medium-insert,#{cls_ins}"
        (e)->
            return false
    )
    # moveCaret = (el, position) ->
    #     position = position or 0
    #     range = document.createRange()
    #     sel = window.getSelection()
    #     if !el.childNodes.length
    #         textEl = document.createTextNode(' ')
    #         el.appendChild textEl
    #     range.setStart el.childNodes[0], position
    #     range.collapse true
    #     sel.removeAllRanges()
    #     sel.addRange range
    #     return





window.MediumEditor = require "medium-editor/dist/js/medium-editor.js"

_toobar = MediumEditor.extensions.toolbar.prototype.createToolbar
MediumEditor.extensions.toolbar.prototype.createToolbar = ->
    toolbar = _toobar.apply @, arguments
    events = @base.events
    $(toolbar).find('.medium-editor-action').click (e)->
        events.triggerCustomEvent('toolbarClick', e, @)
    return toolbar

AutoHR = require('medium-editor-autohr')
defaults = MediumEditor.extensions.button.prototype.defaults
defaults.strikethrough.tagNames.push 'del'
defaults.strikethrough.aria = '删除线'
defaults.pre.tagNames.push 'code'
MediumEditorTable = require "coffee/_lib/medium-editor-tables.coffee"

# <a href="#" style="
# ">+</a>


marked = require('coffee/_lib/marked')
# turndownService.keep(['del', 'u'])

# turndownService.addRule('~~', {
#   filter: ['del', 's', 'strike'],
#   replacement: (content) ->
#     return '~~' + content + '~~'
# })

# replace_tag = (html,a,b)->
#     html = html.replaceAll("<#{a}>","<#{b}>")
#     html = html.replaceAll("<#{a} ","<#{b} ")
#     html = html.replaceAll("</#{a}>","</#{b}>")
#     return html



module.exports =  (box, md, file)->
    _ = $.html()
    for i in "add#新建 post#存档 fly#发布 ask#帮助".split(' ')
    #for i in "add#新建 draft#草稿箱 tag#标签 fly#发布 ask#帮助".split(' ')
        [ico, title] = i.split '#'
        _ """<i class="I I-#{ico}" title="#{title}"></i>"""
    nav = $ """<nav class="edit">#{_.html()}</nav>"""

    box.append(nav)

    box.addClass 'EDIT'
    box.find('.PboxMain').replaceWith require('slm/util/edit')


    f = (s)->
        box.find s

    pbox_ico = f('.PboxIco')
    editor_elem = f '.editor'
# editor.subscribe('editableInput', function (event, editable) {
#     // Do some work
# })
    textarea = f('textarea')[0]
    editor = new MediumEditor(
        textarea
        {
            autoLink: true
            elementsContainer:editor_elem[0]
            spellcheck:false
            targetBlank:true
            paste: {
                forcePlainText: false
                cleanPastedHTML: true
                cleanAttrs: ['class', 'style', 'dir'],
                cleanTags: ['meta','script']
            }
            anchor: {
                placeholderText: '请输入链接',
            }
            toolbar:
                buttons: [
                    'quote'
                    'orderedlist'
                    'unorderedlist'
                    'anchor'
                    {

                        name: 'bold',
                        action: 'bold',
                        aria: '加粗',
                        tagNames: ['b', 'strong'],
                        useQueryState: false
                        contentDefault: '<b>B</b>',
                        contentFA: '<i class="fa fa-bold"></i>'
                        handleClick: (event) ->
                            # 粗体在font-weight不为700的时候识别有问题，没法撤销，需要手工修复，参见 https://github.com/yabwe/medium-editor/issues/908
                            event.preventDefault()
                            event.stopPropagation()
                            @execAction if @isActive() then "removeFormat" else "bold"
                            return
                    }
                    'h2'
                    'h3'
                    'h4'
                    'table'
                    'pre'
                    'strikethrough'
                    'underline'
                    'removeFormat'
                ]
            buttonLabels:'fontawesome'
            placeholder: {
                text: '正文 …'
                hideOnClick: true
            }
            extensions: {
                table: new MediumEditorTable()
                autohr: new AutoHR()
            }
        }
    )

    ed = $(editor.elements)
    wrap_name = "#text BR A SPAN U DEL".split(' ')
    ed.clean = ->
        self = @
        if not ed.html()
            ed.html '<p><br></p>'
        pre = undefined
        p = '<p/>'
        for i in ed.contents()
            name = i.nodeName
            if wrap_name.indexOf(name)>=0
                me = $(i)
                is_span = (name == 'SPAN')
                if pre
                    if is_span
                        html = me.html()
                    else
                        html = i
                    me.remove()
                    pre.append html
                    continue
                if is_span
                    pre = $(p).html(me.html())
                    me.replaceWith(pre)
                else
                    me.wrap p
                    pre = $(i.parentNode)
            else
                pre = 0
            # .each ->
            # me = $ @
            # me.wrap '<p/>'
            # # Fix #145
            # # Move caret at the end of the element that's being wrapped
            # # moveCaret me.parent(), me.text().length
            # return
    EditorAdd box, ed
    editor_elem.on(
        '.medium-editor-action'
        'click'
        ->
            ed.clean()
    )
    h1 = f('input.H1')
    _title = (val)->
        $.doc_title '编辑 · '+($.trim(val) or '无标题')

    _title(
        h1.change(->
            _title @value
            save()
        ).val()
    )
    editor.focus = ->
        editor.elements[0].focus()

    editor.autofocus = ->
        val = $.trim(h1.val())
        h1.val(val)
        if val
            editor.focus()
        else
            h1.focus()

    editor.load_md = (file_, md)->
        md = md.split("\n")
        title = ""
        while md.length
            title = md.shift().replace(/^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g, '')
            if title
                title = $.trim(title.replace(/^#/g, ''))
                if title
                    break
        h1.val title
        md = md.join('\n')

        box.find('.medium-editor-toolbar,.medium-editor-anchor-preview').css({top:0})
        editor.setContent marked(md) or "<p><br></p>"
        ed.clean()
        editor.autofocus()
        file = file_

    editor.load_md(file, md)
    snapshot = =>
        html = editor.getContent()
        title = h1.val()
        return [title+"\n"+html, title, html]

    [initHTML] = snapshot()
    preHTML = initHTML
    saver = undefined
    save = ->
        if saver
            return
        saver = setTimeout(
            _save
            10000
        )

    _save = =>
        if saver
            clearTimeout(saver)
            saver = undefined
         [_html, title, html] = snapshot()
         if _html != preHTML
             preHTML = _html
            System.import("./edit/save.coffee").then (mod)->
                $.ajax = $._ajax
                mod(file, title, html, 0)
                $._ajax = $.ajax

    editor.subscribe(
        'editableInput', save
    )

    editor.subscribe(
        'toolbarClick'
        ->
            ed.clean()
    )

    box.on(
        'rm'
        (event)->
            clearTimeout saver
            [full, title, html] = snapshot()
            if full != initHTML
                System.import("./edit/_box/save").then (mod)->
                    mod(file, title, html)
            return

    )
    # editor.getExtensionByName('placeholder').updatePlaceholder = (el, dontShow)->
    #     contents = $(el).children().not('.medium-insert-buttons').contents()
    #     if not dontShow and contents.length == 1 and contents[0].nodeName.toLowerCase() == 'br'
    #         console.log @showPlaceholder
    #         console.log @base._hideInsertButtons
    #         @showPlaceholder(el)
    #         @base._hideInsertButtons($(el))
    #     else
    #         console.log @hidePlaceholder
    #         @hidePlaceholder(el)


    $.topfix(
        editor_elem, f('.TOP'), f('.TXT'), box
    )


    nav.find('.I').click ->
        _save()
        ico = /I-([^\s]+)/.exec(@className)[1]
        System.import(
            "coffee/_site/edit/"+ico+".coffee"
        ).then(
            (mod)=>
                mod.call(
                    @
                    {
                        file
                        h1
                        editor
                        ico
                    }
                )
        )
        return


