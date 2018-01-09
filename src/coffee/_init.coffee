window.$ = window.jQuery = require "jquery"
window.store = require 'store2'
require 'coffee/_lib/jquery_ext'
require('coffee/_lib/jquery_ajax')

import Vue from 'vue'
import 'coffee/_lib/nprogress/init'
require 'coffee/_lib/box/init'

require 'coffee/_lib/pbox'
require 'coffee/_lib/toast'
require 'coffee/_site/route'
require('coffee/_lib/analytics') 'UA-110552337-1'
require 'coffee/_lib/onload'
require 'scss/_init'

require(
    'coffee/_lib/8gua/ws'
) ->
    PP.getToml(
        "-/init"
        (site)->
            {name, slogan} = site
            window.SITE = {
                ... SITE
                ... site
            }
            if not name
                GO.ln('init')
                return

            title = name
            if slogan
                title += (" · " + slogan)

            $.doc_title title
            $ ->
                require 'coffee/_pop'
                vm = new Vue({
                    el:"#Page"
                    router:GO
                })
    )

# require('coffee/_site/edit')()



