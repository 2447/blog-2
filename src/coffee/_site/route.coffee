import Vue from 'vue'
import VueRouter from "vue-router"
#import VueRouter from "vue-router/dist/vue-router.js"
Vue.use(VueRouter)
window.Vue = Vue

scrollbar = {
    update:=>
}
$ ->
    scrollbar = $.scrollbar(
        $("body")[0]
        (_)->
            $("#Page").css({overflow:'hidden'})
    )

string_dict_default = (s) =>
    s = s.split(' ')
    d = {}
    for i in s
        d[i] = ''
    (o)->
        {
            ...d
            ...o
        }


routes = [
    # {
    #     path:"/test"
    #     component:{
    #       template: '<div>User {{ $route.params.id }}</div>'
    #     }
    # }
]
do =>
    load = (file)->
        (resolve, reject)->
            NProgress.inc()
            done = ->
                vue = arguments[0]
                mod = vue.default
                if 'get' of mod
                    url = mod.get
                    get = PP.get
                else
                    url = file
                    get = PP.getToml
                # 如果get是false就不读数据
                if url
                    tmp = undefined
                    mod_data = mod.data
                    if typeof(mod_data) == 'string'
                        mod_data = string_dict_default(mod_data)


                    mod.data = =>
                        tmp

                    mod.beforeRouteEnter = (to, from, next) ->
                        # $.getJSON url, (o)->
                        get "-/"+url, (o)->
                            tmp = mod_data?(o)
                            if tmp != false
                                next()
                        return

                    # func = mod.func
                    # if func?.sumbit
                    #     func.sumbit = submit(func.sumbit, url)

                resolve mod
                NProgress.done()
                scrollbar.update()
                scrollHash(location.hash)

            System.import(
                "view/#{file}.vue"
            ).then(
                (mod)->
                    done mod
                (err)->
                    done require("view/_status/404.vue")
            )



    make = (file)->
        f = load(file)
        ->
            new Promise(f)

    o = require('coffee/_url')
    for path in o[''].split(' ')
        routes.push {
            path:'/'+path
            component:make(path)
        }

    delete o['']

    for path, file of o
        # type = typeof(file)
        # switch type
            # when 'string'
        routes.push {
            path
            component: make(file)
        }

router = new VueRouter({
    mode: 'history'
    linkActiveClass:'NOW'
    scrollBehavior : (to, from, savedPosition) ->
        scrollbar.update()
        if savedPosition
            return savedPosition
        if to.hash
            scrollHash(to.hash)
        else
            $("#Page").scrollTop(0)

        return { x: 0, y: 0 }
    routes
})

scrollHash = (hash)->
    if hash
        setTimeout(
            ->
                offset = $(hash).position()
                if offset
                    {top} = offset
                else
                    top = 0
                $('#Page').animate({scrollTop:top})
            90
        )


window.GO = router

if history.pushState
    $('body').on 'click', 'a', (e)->
        @blur()
        url = @pathname
        if @hostname != location.hostname or url.slice(0,5) == "/-/S/"
            if not @target
                @target = "_blank"
                @blur()
            return
        else if not $(@).hasClass('go')
            hash = @hash
            if hash
                url += hash
            if url == "#{location.pathname}#{location.hash}"
                if not hash
                    $('#Page').scrollTop(0)
            else
                router.push url
            scrollHash hash
            e.preventDefault()
            return

VueRouter.prototype.ln = (path)->
    pos = path.indexOf(' ')
    history = @history

    route = @match('/'+path.slice(pos+1), history.current)
    history.confirmTransition(
        route
        =>
            history.updateRoute(route)
            setTimeout =>
                history.current = @match(
                    '/'+path.slice(0, pos) , history.current
                )
                history.ensureURL()
    )
    return

VueRouter.prototype.reload = ->
    history = @history
    current = history.current
    history.updateRoute {matched:[], path:""}
    @replace current
    return


