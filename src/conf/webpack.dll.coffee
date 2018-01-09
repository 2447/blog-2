isProduction = (process.env.NODE_ENV == 'production')
path = require("path")
webpack = require('webpack')
SRC = path.resolve(path.join(__dirname,"/.."))
ROOT = path.resolve(SRC+"/..")

MODULE = require("./webpack.module.coffee")

INIT = require("./dll/init.coffee")
plugins = [
    MODULE.extractScss
    require('./webpack.define.coffee')
]
if isProduction
    UglifyJSPlugin = require('uglifyjs-webpack-plugin')
    plugins.push new UglifyJSPlugin({
        test: /\.js$/,
        compress: {
            drop_console:true
            warnings: false
        }
        output:{
            comments: false
        }
    })
    hash = '[chunkhash:8]'
else
    hash = ''


output = {
    filename: "[name]#{hash}.js"
    library: "[name]#{hash}"
    path : path.resolve(path.join(ROOT,'dist/-S/dll'))
}

plugins.push new webpack.DllPlugin({
    path: path.join(ROOT, 'node_modules/8gua-blog.manifest.json'),
    name: "[name]#{hash}",
    context: ROOT,
})

module.exports = {
    module:MODULE.module
    externals: require('./webpack.externals.coffee')
    output
    plugins
    entry: {
        init:INIT
    }
    resolve: require('./webpack.resolve.coffee')
}

