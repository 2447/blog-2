isProduction = (process.env.NODE_ENV == 'production')

path = require("path")
webpack = require('webpack')
ROOT = path.resolve(path.join(__dirname,"../.."))
outputDir = path.join(ROOT, 'dist')

#console.log path.resolve(__dirname, "..")
CONFIG = require('./config.coffee')


output = {
    path: path.join(outputDir, '-S')
}

if isProduction
    # sourceMap = "?prefix=/xxxximg"
    output.filename = '[chunkhash:8].js'
    output.chunkFilename = output.filename
    output.publicPath = CONFIG.CDN

else
    output.chunkFilename = '-S/[name].js'
    output.filename = '-S/[name].js'
    output.publicPath = "/"

exports = {
    entry:
        site : ['./coffee/_init.coffee']
    output: output
    externals: require('./webpack.externals.coffee')
    resolve: require('./webpack.resolve.coffee')
    devServer:
        contentBase: outputDir
}



Object.assign(exports, require("./webpack.loader.coffee"))

    # WebpackChunkHash = require('./webpack-chunk-hash.js')
    # exports.plugins.push(
    #     new WebpackChunkHash()
    # )
# if isProduction
# exports.plugins.push(
#     new webpack.optimize.CommonsChunkPlugin({
#         # async:"C2"
#         filename: output.filename
#         names: ["site"]
#         minChunks:2
#         name:'C2'
#     })
# )
module.exports = exports
