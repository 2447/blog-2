webpack = require('webpack')
HtmlWebpackPlugin = require('html-webpack-plugin')
isProduction = (process.env.NODE_ENV == 'production')
OptimizeCssAssetsPlugin = require('optimize-css-assets-webpack-plugin')
MODULE = require("./webpack.module.coffee")
path = require 'path'
ROOT = path.resolve(path.join(__dirname,"../.."))


CopyWebpackPlugin = require('copy-webpack-plugin')
AddAssetHtmlPlugin = require('add-asset-html-webpack-plugin')


module.exports = exports = {
    module:MODULE.module
    plugins: [
        new webpack.HashedModuleIdsPlugin()
        MODULE.extractScss
        require('./webpack.define.coffee')
        new webpack.DllReferencePlugin({
            context: ROOT
            manifest: path.join(ROOT,'node_modules/8gua-blog.manifest.json')
        })
    ]
}


HTML_WEBPACK_PLUGIN_CONFIG = [
    [

        '_seo'
        "seo"
        ['seo']
    ],
    [
        '_init'
        "index"
        ['site']
    ]
]


do ->
    files = []

    for [template, filename, chunks] in HTML_WEBPACK_PLUGIN_CONFIG
        filename = filename+".html"
        exports.plugins.push new HtmlWebpackPlugin(
            {
                template: './slm/'+template+'.slm'
                inject: 'body'
                filename
                chunks
                # chunks:'C2 site'.split(' ')
                minify:{
                    removeScriptTypeAttributes:true
                    removeAttributeQuotes:true
                    removeComments:true
                    collapseWhitespace:true
                }
            }
        )
        files.push(filename)


    exports.plugins.push(
        new AddAssetHtmlPlugin({
            filepath: path.join(ROOT,'dist/-S/dll/init*.js')
            files
            includeSourcemap:false
        })
    )


if isProduction
    # exports.plugins.push new webpack.DefinePlugin({
    #     'process.env': {
    #         NODE_ENV: '"production"'
    #     }
    # })
    # ParallelUglifyPlugin = require('webpack-parallel-uglify-plugin')
    UglifyJSPlugin = require('uglifyjs-webpack-plugin')

    exports.plugins.push (
        new UglifyJSPlugin({
            test: /\.js$/,
            compress: {
                drop_console:true
                warnings: false
            }
            output:{
                comments: false
            }
        })
    )
    exports.plugins.push new OptimizeCssAssetsPlugin({
        assetNameRegExp: /\.css$/,
        cssProcessorOptions: { discardComments: { removeAll: true } }
    })
else
    exports.devtool = "source-map"
    exports.plugins.push(
        new CopyWebpackPlugin([
            {
                from:path.join(ROOT,'src/-')
                to:'-'
            }
            {
                from:path.join(ROOT,'dist/favicon.ico')
                to:'favicon.ico'
            }
        ])
    )
