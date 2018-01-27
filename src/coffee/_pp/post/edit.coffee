module.exports = (url, box, callback)->
    edit = $(
        """<a href="/edit/#{url}.md" class="I I-edit PboxIco" style="font-size:24px;bottom:11px;right:8px;top:auto;"></a>"""
    ).click =>
        callback()
        return
    console.log box
    box.append edit
