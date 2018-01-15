window.$ = window.jQuery = require "jquery"
window.store = require 'store2'
require 'coffee/_lib/jquery_ext'
require('coffee/_lib/jquery_ajax')
require 'coffee/_lib/tld_domain'

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
            if name
                window.SITE = site

                title = name
                if slogan
                    title += (" · " + slogan)
                $.DOC_TITLE = title
                $.doc_title()
            $ ->
                require 'coffee/_pop'
                vm = new Vue({
                    el:"#Page"
                    router:GO
                })
    )

# require('coffee/_site/edit')()



