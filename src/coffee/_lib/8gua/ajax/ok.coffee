err = require 'coffee/_lib/8gua/ajax/err.coffee'

module.exports = (HOST_URL, callback)->
    func = (f)->
        ->
            arguments[0] = HOST_URL+arguments[0]
            f.apply @, arguments

    $.get(
        HOST_URL
    ).then(
        (code)->
            code = code - 0
            if code
                err code
            else
                require('./bind') func, func

            callback()
        ->
            err 0
            callback()
    )



# do ->
#     for i in "getJSON1 postJSON1 get1 post1 getJSON get post postJSON".split(' ')
#         module.exports[i] = bind(i)


# $.get({
#     url: "https://8gua.men:19840/-/3333/3.md",
#     crossDomain: true,
#     data:"hello",
#     processData:true,
#     contentType: "text/plain",
#     method: "GET",
#     success:console.log
# })

