module.exports = ({file, editor})->
    System.import(
        "coffee/_site/edit/menu/_box/page"
    ).then (box)=>
        box().then (url, md)->
            editor.load_md(
                "~/"+url+".md"
                md
            )
        return
