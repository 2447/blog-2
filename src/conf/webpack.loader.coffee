webpack = require('webpack')
HtmlWebpackPlugin = require('html-webpack-plugin')
isProduction = (process.env.NODE_ENV == 'production')
OptimizeCssAssetsPlugin = require('optimize-css-assets-webpack-plugin')
MODULE = require("./webpack.module.coffee")
path = require 'path'
ROOT = path.resolve(path.join(__dirname,"../.."))


HTML_WEBPACK_PLUGIN_CONFIG = {
    template: './slm/_init.slm'
    inject: 'body'
    filename:'index.html'
    chunks:['site']
    # chunks:'C2 site'.split(' ')
    minify:{
        removeScriptTypeAttributes:true
        removeAttributeQuotes:true
        removeComments:true
        collapseWhitespace:true
    }
}

CopyWebpackPlugin = require('copy-webpack-plugin')
AddAssetHtmlPlugin = require('add-asset-html-webpack-plugin')


module.exports = exports = {
    module:MODULE.module
    plugins: [
        new webpack.HashedModuleIdsPlugin()
        new HtmlWebpackPlugin(HTML_WEBPACK_PLUGIN_CONFIG)
        MODULE.extractScss
        require('./webpack.define.coffee')
        new webpack.DllReferencePlugin({
            context: ROOT
            manifest: path.join(ROOT,'node_modules/8gua-blog.manifest.json')
        })
        new AddAssetHtmlPlugin({
            filepath: path.join(ROOT,'dist/-S/dll/init*.js')
            files: ['index.html']
            includeSourcemap:false
        })
    ]
}
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
