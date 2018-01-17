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




