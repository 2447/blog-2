loaderUtils = require('loader-utils')
slm = require('slm')
markdown = require('slm-markdown')
markdown.register slm.template
require("./slm_ext.coffee")

module.exports = (source) ->
    @cacheable and @cacheable(true)
    resolveRoot = @options and @options.resolve and @options.resolve.root
    options = loaderUtils.getOptions(this) or {}
    if !options.basePath and resolveRoot
        options.basePath = resolveRoot
    options.filename = @resource
    tmplFunc = slm.compile(source, options)
    # watch for changes in every referenced file
    Object.keys(slm.template.VM::_cache).forEach ((dep) ->
        @addDependency dep
        return
    ), this
    # slm cache used to remember paths to all referenced files
    # purge cache after each run to force rebuild on changes
    # each cached chunk is deleted from original object,
    # cause it's referenced by slm internally in other places
    # replacing cache with new object {} will break hot reload
    Object.keys(slm.template.VM::_cache).forEach (dep) ->
        delete slm.template.VM::_cache[dep]
        return
    tmplFunc()
