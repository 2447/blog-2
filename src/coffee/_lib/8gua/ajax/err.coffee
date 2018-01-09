module.exports = (code)->
    require(
        'coffee/_lib/8gua/ajax/bind'
    )(
        =>
            ->
                require('./box')(code)
                d = $.Deferred()
                d.reject()
                d
        (f)=>
            f
    )
