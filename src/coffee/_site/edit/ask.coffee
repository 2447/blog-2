module.exports = (callback)->
    System.import("coffee/_site/edit/_slide").then (slideout)->
        slideout (resolve)->
            resolve(
                callback(require('./ask.slm'))
            )
