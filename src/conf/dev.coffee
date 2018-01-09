webpackDevServer = require("webpack-dev-server")
CONFIG = require "./config"
webpack = require("webpack")
config = require("./webpack.config.coffee")

do ->
    li = config.entry.site
    li.unshift('webpack/hot/dev-server')
    li.unshift("webpack-dev-server/client?http://#{CONFIG.HOST}")

config.plugins.push new webpack.HotModuleReplacementPlugin()


compiler = webpack(
    config
)
compiler.plugin(
    "done"
    ->
        console.log("\n开发服务器启动成功！\n请访问 http://"+CONFIG.HOST+":"+CONFIG.PORT+"\n")

)

server = new webpackDevServer(compiler, {
    watchOptions: {
        ignored: [
            /\.sw[pon]$/
            /-/
            /file/
        ]
    }
    stats: { colors: true , process:true}
    contentBase:"./dist"

    public:"#{CONFIG.HOST}"
    index:'index.html'

    historyApiFallback: {
        rewrites: [
            {
                from: /\/(\d\..*\.js(\.map)?)/
                to: (context) ->
                    "/js"+context.match[0]
            }
            {
                from: /.*/
                to: (context) ->
                    "/"
            }
        ]
    }
})

server.listen(
    CONFIG.PORT
    '0.0.0.0'
)

