
_ing = undefined
module.exports = (code) ->
    if _ing
        return
    _ing = 1
    $.box.alert(
        "<h1>"+require("./err/#{code}.slm")+"</h1>"
    ).on(
        'close'
        ->
            _ing = undefined
    )
