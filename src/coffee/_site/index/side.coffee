
# /* .a */
# /*     a href="/" 注册登录 */
# .a
#     a href="/about" 关于作者
# .a
#     a href="/link" 友情链接
# .a
#     a href="/help" 站点说明

module.exports = ->
    html = $ require('slm/index/side').render(SITE)
    _ = $.html()
    for [link, name] in SITE.menu
        _ """<div class="a"><a href="/#{link}">#{$.escape name}</a></div>"""
    html.find('.VC').append _.html()

    require('coffee/_lib/slideout')(
        $ '.Page'
        html
        "Right"
    )
