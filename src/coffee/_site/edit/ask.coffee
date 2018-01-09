module.exports = System.import("./_slide").then (slideout)->
    slideout (resolve)->
        resolve require('./ask.slm')
