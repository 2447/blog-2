module.exports = (file, title, html)->
    new Promise(
        (resolve, reject)->
            save = (git)->
                ->
                    System.import("../save.coffee").then(
                        (mod)->
                            mod(
                                file
                                title
                                html
                                git
                            )
                            resolve()
                    )
            ok = save()
            if file.slice(0,8) == "!/draft/"
                ok()
            else
                $.box.confirm(
                    "<h1 class=TC><p>内容有改动。</p><p>是否要保存？</p></h1>"
                    {
                        okBtn:'保存'
                        cancelBtn:'不'
                        ok
                        cancel:save(0)
                    }
                )
    )
