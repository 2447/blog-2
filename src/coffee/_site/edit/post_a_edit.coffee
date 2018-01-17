module.exports = (editor, option, h)->
    h.find('.I-edit').click ->
        p = $(@).closest('li')[0].title
        System.import("coffee/_site/edit/_load").then(
            (load)->
                load(
                    p
                    (md)->
                        editor.load_md p, md
                        option.slide.close()
                )
        )
