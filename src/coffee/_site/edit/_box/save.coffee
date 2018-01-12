module.exports = (file, title, html)->
    new Promise(
        (resolve, reject)->
            save = (git)->
                System.import("../save.coffee").then(
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
            if file.slice(0,8) == "!/draft/"
                save()
            else
                save(0)
    )
