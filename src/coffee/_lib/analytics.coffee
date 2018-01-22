window.dataLayer = window.dataLayer || []

window.gtag = ->
    dataLayer.push(arguments)

gtag 'js', new Date()
ID = "UA-110552337-1"
$("head").append("""<script async src="//www.googletagmanager.com/gtag/js?id=#{ID}"></script>""")

GO.afterEach (to)->
    gtag 'config', ID



