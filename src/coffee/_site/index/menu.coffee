module.exports = ->
    require('coffee/_lib/slideout')(
        $ '.Page'
        require('slm/index/menu').render SITE
        "Right"
    )
