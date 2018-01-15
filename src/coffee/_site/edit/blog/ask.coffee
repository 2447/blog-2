module.exports = System.import("coffee/_site/edit/_slide").then (slideout)->
    slideout (resolve)->
        resolve require('./ask.slm')
