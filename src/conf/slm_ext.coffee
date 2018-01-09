slm = require('slm')
sass = require('node-sass')
fs = require('fs')
coffee = require('coffeescript')
stripBom = require('strip-bom')


slm.template.registerEmbeddedFunction 'slm', (string) ->
    li = string.split('\n')
    result = []
    for i in li
        path = i.trim()
        if path
            slm_code = fs.readFileSync("slm/#{path}.slm", 'utf-8')
            html = slm.compile(slm_code,
                filename: path
                basePath: '.')()
            result.push html
    result.join("")

slm.template.registerEmbeddedFunction 'coffee', (string) ->
    result = '<script>'
    result += coffee.compile(string)
    result += '</script>'

slm.template.registerEmbeddedFunction 'scss', (string) ->
    [
        '<style>'
        stripBom(
            sass.renderSync(
                {
                    data: string
                    outputStyle:'compressed'
                }
            ).css.toString()
        )
        '</style>'
    ].join('')
