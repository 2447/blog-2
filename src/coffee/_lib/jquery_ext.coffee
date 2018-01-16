$.isMobile = /Mobi/i.test(navigator.userAgent) || /Android/i.test(navigator.userAgent)

isMac = navigator.appVersion.indexOf("Mac")!=-1

$.topfix = (scroll, top, body, box)->
    pre_x = 0
    pre_diff = 0
    clsname = 'Topfix'
    cl = clsname.toLowerCase()
    page = $(scroll)
    box = box or page
    t = box.find(top)

    t_h = t.height() + (t.css('marginBottom').slice(0,-2) - 0)

    pd = (h)->
        box.find(body).css {
            paddingTop:h
        }
    page.scroll(
        ->
            x = page.scrollTop()
            if x < 2
                box.removeClass clsname
                t.removeClass cl
                pd ''
                callback?(-1)
                return
            diff = x - pre_x
            if Math.abs(diff) > 20
                has = t.hasClass cl
                pre_x = x
                if (diff > 0 and pre_diff < 0)
                    if has
                        clstop 0
                if x > t_h
                    if (diff < 0 and pre_diff > 0)
                        clstop 1
                        if not has
                            t.addClass(cl)
                            pd t_h
                    else if not box.hasClass clsname
                        clstop 0
                        box.addClass(clsname)
                pre_diff = diff
    )
    clstop = (code)->
        callback?(code)
        box.removeClass(clsname+(not code - 0 ))
        box.addClass(clsname+code)

        # a = t_e.className
        # pos = a.indexOf(animated)
        # if pos >= 0
        #     a = a.slice(0, pos)
        # t_e.className = a + animated + c
        # t_e.style.position = position
        # if position == fixed
        #     paddingTop = t_h
        # else
        #     page.removeClass(clsname)
        #     paddingTop = ''

$.scrollbar = (elem, callback)->
    f = =>
    s = {
        update:f
        destroy:f
    }
    if not ($.isMobile or isMac)

        System.import('smooth-scrollbar').then (Scrollbar)->
            scrollbar = Scrollbar.default.init(elem)
            callback?(scrollbar)
            s.update = =>
                scrollbar.update()
            s.destroy = =>
                scrollbar.destroy()
    return s

$.ajaxSetup({
    crossDomain: true,
    xhrFields: {
        withCredentials: true
    }
})

# if $.isMobile
#     window.scrollbar = ->
#         {
#             update:=>
#         }
# else
#     Scrollbar = require 'perfect-scrollbar/dist/perfect-scrollbar.js'
#     window.scrollbar = (elem, option)->
#         return new Scrollbar(elem, option)
tagsToReplace = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;'
}



$.extend($,{
selected : ->
     a = ""
     win = window
     if win.getSelection
          a = win.getSelection().toString()
     else
        s = document.selection
        if s && "Control" != s.type
            a = win.document.selection.createRange().text
     return $.trim(a)
html : ->
    r = []
    _ = (o) -> r.push o
    _.html = -> r.join ''
    _
escape : (str) =>
    # Here is a performance test: http://jsperf.com/encode-html-entities to compare with calling the replace function repeatedly, and using the DOM method proposed by Dmitrij.
    return str.replace(/[&<>]/g, (tag)=>tagsToReplace[tag] || tag)
DOC_TITLE : ''
doc_title : (title)->
    document.title = title or $.DOC_TITLE
txt2html : (txt)->
    r = []
    for i in txt.replace(/\r\n/g, "\n").replace(/\r/g, "\n").split("\n")
        r.push($.escape i)
    return "<p>" + (r.join("</p><p>")) + "</p>"
isodate : (day) ->
    if day == undefined
        date = new Date()
    else
        date = new Date(day * 86400000 )
    result = [date.getMonth() + 1, date.getDate()]
    now = new Date()
    full_year = date.getFullYear()
    result.unshift full_year  unless now.getFullYear() is full_year
    result.join("-")
})

# window._TITLE = document.title

# pad_number = (n)->
#     if n <= 9
#         n = "0"+n
#     return n

escapeRegExp = (str) ->
    str.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")

String.prototype.replaceAll = (search, replacement) ->
    @replace(new RegExp(escapeRegExp(search), 'g'), replacement)


String.prototype.render = (dict) ->
    s = []
    for k,v of dict
        s.push "%#{escapeRegExp(k)}"
    s = new RegExp(s.join('|'), 'g')
    @replace(s, (match)->
        return dict[match.slice(1)]
    )

# $.extend {
#     toFixed : (n, len=4, digit_min=2)->
#         digit = (n+"").length-1-(((n+"").replace(".","")-0)+"").length
#         if digit > 0
#             digit += (len-1)
#         else
#             if n < 10
#                 digit = digit_min+1
#             else
#                 digit = digit_min
#         return n.toFixed(digit)


#     sign_n: (n)->
#         if n > 0
#             n = "+ #{n}"
#         else if n < 0
#             n = "- #{-n}"
#         n



#     isomonth : (day)->
#         date = new Date(day * 86400000 )
#         result = [date.getFullYear(), pad_number(date.getMonth() + 1)]
#         result.join("-")


#     isotime : (timestring) ->
#         date = new Date(timestring * 1000)
#         result = [
#             pad_number(date.getMonth() + 1)
#             pad_number(date.getDate())
#         ]

#         full_year = date.getFullYear()
#         if (new Date()).getFullYear() != full_year
#             result.unshift full_year

#         result.join("-") + " " + [
#             pad_number(date.getHours())
#             pad_number(date.getMinutes())
#         ].join(":")
# }
require("./jquery_err")

$.fn.extend {
    save:(fn, dict)->
        defer = $.Deferred()
        if typeof(fn) == 'string'
            url = fn
            fn = (d)->
                PP.postJSON1(url, d)
        form = @
        dict = dict or {}
        submit = ->
            $.extend(dict, form.dict())
            fn(dict).then(
                ->
                    $.err form, {}
                    defer.resolve(dict, ...arguments)
                (err)->
                    err = err.responseJSON
                    if typeof(err) == "string"
                        $.box.alert """<div style="color:red;font-weight:bold">#{err}</div>"""
                    else
                        $.err form, err
            )
            false
        @submit submit
        setTimeout ->
            is_focus = 0
            li = form.find("input:enabled")
            for i in li
                if not i.value
                    is_focus = 1
                    i.focus()
                    i.select()
                    break
            if not is_focus
                $(li[0]).focus().select()
        return defer
    dict:->
        _ = {}
        for i in @find("input:enabled,select")
            if i.name
                $i = $ i
                v = _[i.name] = $.trim $i.val()
                $i.val v
        return _
}

#     fill:(dict)->
#         for k,v of dict
#             @find("[name=#{k}]").val v
#         @

#     # js : (map)->
#     #     for action, url of map
#     #         @one action,->
#     #             require "coffee/#{url}.coffee"
#     #     @

#     # satoshi : require("coffee/_misc/satoshi")
#     ctrl_enter : (callback) ->
#         $(this).keydown(
#             (event) ->
#                 event = event.originalEvent
#                 if event.keyCode == 13 and (event.metaKey or event.ctrlKey)
#                     callback?()
#                     false
#         )
#         @
# }
