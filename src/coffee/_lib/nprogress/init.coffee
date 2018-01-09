nprogress = require('./src.coffee')

n = 0
window.NProgress= {
    inc: =>
        if not n
            nprogress.start()
        n += 1
        return
    done: =>
        n -= 1
        if not n
            nprogress.done()
        return
}

