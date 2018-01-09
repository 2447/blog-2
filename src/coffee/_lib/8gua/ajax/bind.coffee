
bind = (li, func)->
    for i in li.split(' ')
        PP[i] = func($[i])


module.exports = (post, get)->
    bind "post postJSON1 post1 postJSON postToml", post
    bind "get getJSON1 get1 getJSON getToml", get
    PP.json = post($.getJSON)

