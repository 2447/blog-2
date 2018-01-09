$._ajax = $.ajax



$.ajax = ->
    NProgress.inc()
    $._ajax.apply(@,arguments).always ->
        NProgress.done()

_method = (method, parse=$.parseJSON) =>
    (url, data, callback) ->
        if jQuery.isFunction data
            callback = data
            data = {}
        data = data||{}

        option = {
            url
            data
            type: method
            # success: _ajax_success(callback)
        }
        if callback
            option.success = ->
                arguments[0] = parse(arguments[0])
                callback.apply @, arguments
        return jQuery.ajax option


toml_parse = require("toml").parse
_getToml = _method("GET", (o)=>
    if o
        return toml_parse o
    return {}
)

_url = (args)=>
    url = args[0]+".toml"
    if url.indexOf("://") < 0
        url = "/#{url}"
    args[0] = url
    return args

$.postToml = ->
    $.postJSON.apply @, _url(arguments)

$.getToml = ->
    _getToml.apply @, _url(arguments)


$.postJSON = (url, data, callback)->
    if $.isFunction data
        callback = data
        data = {}
    data = JSON.stringify(data||{})
    option = {
        url
        data
        type: "POST"
        processData:true
        contentType: "text/plain"
        dataType: "json"
    }
    if callback
        option.success = callback
    return $.ajax option

_ajaxing = []


ajaxing = (func) ->
    (url, data, callback) ->

        if _ajaxing.indexOf(url)+1
            return

        _ajaxing.push url

        func.apply(@,arguments).always ->
            _ajaxing.splice(_ajaxing.indexOf(url),1)

$.postJSON1 = ajaxing($.postJSON)
$.getJSON1 = ajaxing($.getJSON)
$.get1 = ajaxing($.get)
$.post1 = ajaxing($.post)




# _ajax_success = (callback) ->
#     _ = (data, textStatus, jqXHR) ->
        # if data and data.error
        #     error = data.error
            # if error.code == 403
            #     return $$("SSO.login")
            # else if error.html
            #     $.is_posting = 0
            #     return $.fancybox({content:error.html})

        # if callback
        #     callback(data, textStatus, jqXHR)
    # return _


