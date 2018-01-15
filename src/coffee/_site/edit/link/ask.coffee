module.exports = System.import("../ask").then (ask)->
    ask (html)->
        html = $(html)
        html.find('ol').append require('./ask.slm')
        return html
