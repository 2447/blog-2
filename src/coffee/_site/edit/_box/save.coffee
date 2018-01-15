module.exports = (file, title, html)->
    new Promise(
        (resolve, reject)->
            save = (git)->
                System.import("coffee/_site/edit/save.coffee").then(
                    (mod)->
                        opt = {}
                        if git != undefined
                            opt.git = git
                        mod(
                            file
                            title
                            html
                            opt
                        )
                        resolve()
                )
            if file.slice(0,2) == "$/"
                save()
            else
                save(0)
    )
