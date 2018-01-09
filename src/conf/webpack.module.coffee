isProduction = (process.env.NODE_ENV == 'production')
CONFIG = require('./config.coffee')

ExtractTextPlugin = require("extract-text-webpack-plugin")
extractScss = new ExtractTextPlugin("[chunkhash].css")
if isProduction
    sourceMap = ""
else
    sourceMap = "?sourceMap"

HTML_LOADER = """html-minify-loader!./conf/slm-loader.coffee"""
BABEL_LOADER = """babel-loader?presets[]=env"""
#BABEL_LOADER = """babel-loader?presets[]=env"""
path = require 'path'

module.exports = {
    module:{
        rules: [
            # { test: './src/coffee/index.coffee', loader: "exports?avalon!coffee-loader" }
            {
                test: /\.coffee$/
                loader: [
                    BABEL_LOADER
                    """coffee-loader#{sourceMap}"""
                ]
            }
            {
                test: /\.js$/
                exclude: /(node_modules|bower_components)/
                use: {
                    loader: 'babel-loader'
                    options: {
                      presets: ['env']
                      plugins: [require('babel-plugin-transform-object-rest-spread')]
                    }
               }
            }
            {
                test: /\.vue$/
                loader:"vue-loader"
                options : {
                    loaders:{
                        slm:"""html-minify-loader!#{__dirname}/slm-loader.coffee"""
                        coffee:[
                            BABEL_LOADER
                           "coffee-loader"
                        ]
                        css:"""style-loader!css-loader?root=/!sass-loader#{sourceMap}"""
                    }
                }
            }
            {
                loader: extractScss.extract({
                    fallback:'style-loader'
                    use:["css-loader?root=/","sass-loader#{sourceMap}"]
                    publicPath: if isProduction then CONFIG.CDN else "/"
                }
                )
                # use:['style-loader',"css-loader?root=/","sass#{sourceMap}"]
                test: /\.(s?css)$/
            }
            {
                test: /\.slm$/
                loader: "raw-loader!#{HTML_LOADER}"
            }
            {
                test: /\.(woff|woff2|ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/
                loader: 'url-loader?limit=1&name=[name].[hash:base62:5].[ext]'
            }
            {
                test: /\.(png|jpg|gif)$/
                use: [
                    "file-loader?limit=2000&name=[hash:base62:7].[ext]"
                    'image-webpack-loader'
                ]
            }
        ]
    }
    extractScss:extractScss
}
