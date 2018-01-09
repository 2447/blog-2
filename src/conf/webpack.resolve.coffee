path = require("path")
ROOT = path.resolve(path.join(__dirname,"../.."))
module.exports = {
    modules: [
        path.join(ROOT, 'src')
        path.join(ROOT, "node_modules")
    ]
    extensions: '.coffee .vue .slm .scss .js'.split(' ')
    alias:
        vue$: 'js/vue.js'
}
