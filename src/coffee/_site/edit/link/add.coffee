module.exports = ({file})->
    System.import(
        "coffee/_site/edit/link/_box/page"
    ).then (box)=>
        box()
        return
