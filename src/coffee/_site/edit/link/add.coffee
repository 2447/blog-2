module.exports = ({file, editor})->
    System.import(
        "coffee/_site/edit/link/_box/page"
    ).then (box)=>
        box().then (url)->
            editor.load_md(
                "~/"+url+".md"
                ''
            )
        return
