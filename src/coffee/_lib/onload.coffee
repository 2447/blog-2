con = window.console
if con
    style = 'margin:12px 0;font-size:24px;line-height:24px;color:#'
    con.log(
        '%c\n是看代码实现，还是发现了什么BUG？\n\n%c不如同来构建世界吧！\n\n%c项目网址 https://8gua.blog\n\n'
        style+'f00'
        style+'390'
        style+'00f'
    )

body = $ 'body'
if window.devicePixelRatio > 1
    body.addClass('retina')
if $.isMobile
    body.addClass 'M'


if window.getSelection and document.createRange
    seletor = {
        save : (containerEl) ->
          doc = containerEl.ownerDocument
          win = doc.defaultView
          range = win.getSelection().getRangeAt(0)
          preSelectionRange = range.cloneRange()
          preSelectionRange.selectNodeContents containerEl
          preSelectionRange.setEnd range.startContainer, range.startOffset
          start = preSelectionRange.toString().length
          {
            start: start
            end: start + range.toString().length
          }

        restore : (containerEl, savedSel) ->
            doc = containerEl.ownerDocument
            win = doc.defaultView
            charIndex = 0
            range = doc.createRange()
            range.setStart containerEl, 0
            range.collapse true
            nodeStack = [ containerEl ]
            node = undefined
            foundStart = false
            stop = false
            while !stop and (node = nodeStack.pop())
              if node.nodeType == 3
                nextCharIndex = charIndex + node.length
                if !foundStart and savedSel.start >= charIndex and savedSel.start <= nextCharIndex
                  range.setStart node, savedSel.start - charIndex
                  foundStart = true
                if foundStart and savedSel.end >= charIndex and savedSel.end <= nextCharIndex
                  range.setEnd node, savedSel.end - charIndex
                  stop = true
                charIndex = nextCharIndex
              else
                i = node.childNodes.length
                while i--
                  nodeStack.push node.childNodes[i]
            sel = win.getSelection()
            sel.removeAllRanges()
            sel.addRange range
    }

else if document.selection
    selector = {
      save : (containerEl) ->
        doc = containerEl.ownerDocument
        win = doc.defaultView or doc.parentWindow
        selectedTextRange = doc.selection.createRange()
        preSelectionTextRange = doc.body.createTextRange()
        preSelectionTextRange.moveToElementText containerEl
        preSelectionTextRange.setEndPoint 'EndToStart', selectedTextRange
        start = preSelectionTextRange.text.length
        {
          start: start
          end: start + selectedTextRange.text.length
        }

      restore : (containerEl, savedSel) ->
        doc = containerEl.ownerDocument
        win = doc.defaultView or doc.parentWindow
        textRange = doc.body.createTextRange()
        textRange.moveToElementText containerEl
        textRange.collapse true
        textRange.moveEnd 'character', savedSel.end
        textRange.moveStart 'character', savedSel.start
        textRange.select()
    }

body.bind 'copy', (e)->
    target = e.target
    if ['TEXTAREA','INPUT'].indexOf(target.tagName) >= 0
        return
    if $(target).parents(".medium-editor-element")[0]
        return

    s = $.selected()
    if s and s.length >= 50
        title = document.title
        href = location.href
        tip = "来源 : "
        html = "<div>"+$.txt2html(s)+"""<br><p>#{tip}#{$.escape title} ( <a href="#{$.escape href}" target="_blank">#{$.escape href}</a> )</p></div>"""
        c = e.originalEvent.clipboardData || window.clipboardData
        if c
            p = 'text/plain'
            txt = s+"\n\n#{tip}"+title+" ( #{href} )"
            c.setData(p, txt)

            if c.getData(p)
                c.setData('text/html', html)
                e.preventDefault()
            return
         select = window.getSelection
         if select
             range = seletor.save(@)
             self = @
             n = $(html).css({position: 'fixed', left: "-9999px" }).appendTo(body)
             select().selectAllChildren n[0]
             setTimeout(
                ->
                    n.remove()
                    seletor.restore(self, range)
                200
             )


