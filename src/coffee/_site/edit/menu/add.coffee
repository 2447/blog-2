module.exports = System.import("../blog/add").then (add)->
    return add

# module.exports = ({file, editor})->
#     System.import(
#         "coffee/_site/edit/menu/_box/page"
#     ).then (box)=>
#         box().then (url, md)->
#             editor.load_md(
#                 "!/"+url+".md"
#                 md
#             )
#         return
