module.exports = (ID)->
    window.dataLayer = window.dataLayer || []

    window.gtag = ->
        dataLayer.push(arguments)

    gtag 'js', new Date()

    GO.afterEach (to)->
        gtag 'config', ID

    $('body').append(
        """<script async src="//www.googletagmanager.com/gtag/js?id=#{ID}"></script>"""
    )


