window.dataLayer = window.dataLayer || []

window.gtag = ->
    dataLayer.push(arguments)

module.exports = ID = "UA-110552337-1"
gtag('js', new Date())
gtag 'config', ID

$("head").append("""<script async src="//www.googletagmanager.com/gtag/js?id=#{ID}"></script>""")

