isProduction = (process.env.NODE_ENV == 'production')
webpack = require('webpack')

if isProduction
    DEFINE = {
        'process.env': {
            NODE_ENV: '"production"'
        }
    }
else
    DEFINE = {}

DEFINE.__DEBUG__ = not isProduction

module.exports = new webpack.DefinePlugin(DEFINE)
