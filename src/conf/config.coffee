
try
    CONFIG = require('./config.local.coffee')
catch
    CONFIG = require('./config.default.coffee')


module.exports = CONFIG
