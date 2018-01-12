ReconnectingWebSocket = require 'reconnecting-websocket'


HOST = "8gua.win"
PORT = 19841
F = "/-/"
window.PP = {
    URL : "https://#{HOST}:#{PORT-1}/"
    F
}


module.exports = (callback)->
    window.WS = ws = new ReconnectingWebSocket("wss://#{HOST}:#{PORT}")

    _callback = ->
        if callback
            $(document).ajaxError (event, {status}, {url}) ->
                #     if url.indexOf(PP.URL) == 0
                #         require('./ajax/box') 0
                #         return
                if status == 412 or status == 200
                    return
                $.box.alert("""<h1><p>出错了！错误代码: #{status}</p><p style="word-break: break-all">请求地址 :</p><p><a target="_blank" href="#{url}">#{url}</p></h1>""")
            callback()
            callback = undefined
        return



    ws.onmessage = (e) ->
        {data} = e
        action = data.charAt(0)
        msg = data.slice(1)
        switch action
            when "^"
                $.toast msg

    ws.onclose = ->
        if PP.open
            delete PP.open
            PP.F = F
            $.toast '后台连接中断'
        require('coffee/_lib/8gua/ajax/err.coffee')(0)
        _callback()

    ws.onopen = ->
        PP.open = 1
        PP.F = PP.URL+F.slice(1)
        System.import(
            'coffee/_lib/8gua/ajax/ok.coffee'
        ).then (mod)->
            mod(
                PP.URL
                _callback
            )
