<style lang="scss">
#PBY{
.poLi{
    .li{
        min-height:64px;
        border-bottom:1px solid #eee;
        .title{
            color:#999;
            padding: 18px;
        }
    }
}
section.bar{
    border-top: 0;
    background:#fdfdfd;
    box-shadow: rgba(0,0,0,.05) 0 0 5px inset;

    a{
        color:#000;
		text-overflow: ellipsis;
		overflow: hidden;
		position: absolute;
		right: 78px;
		height: 64px;
		line-height: 64px;
		display: inline-block;
		white-space: nowrap;
		left: 18px;
    }
    .I-close{
        &:before{
            transition: all .25s ease;
            transform: rotate(45deg);
            display:inline-block;
        }
        &.X:before{
            transform: rotate(0);
        }
    }
}
header{
    text-align:center;
    background: url(../scss/file/pagebg.png) 0 0 / 190px #FAFAFA;
    box-shadow: 0 -3px 3px -3px #eee inset;
    .siteH2{
        padding: 30px 24px 35px;
        background:rgba(255,255,255,.2);
        h1,h2{
            letter-spacing:3px;
            font-size: 23px;
            font-weight: normal;
            margin: 0;
            font-family: Rajdhani, H;
        }
        h2{
            letter-spacing:1px;
            font-size: 14px;
        }
    }
}
}
</style>


<template lang="slm">
#PBY
    .Ptop
        .L
            a.logo href="/"
                i class="I I-logo"
                b class="h1" {{hostname}}
        .R
            i v-on:click="menu" class="I I-menu IBtn on"
    .Pbody
        header
            .siteH2
                h1 {{name}}
                h2 v-if="slogan" {{slogan}}
        .bar
            .R.split
                a.I.I-edit.IBtn href="/edit"
            .aLi
                a.now href="/" 目录
                a href="/reply"
                    | 回复
        .MB90


        slm:
            util/footer
</template>


<script lang="coffee">
SUMMARY = []
export default {
    get : "md/SUMMARY.md"
    data:(summary)->
        count = 0
        li = []
        for line in summary.split("\n")
            i = $.trim line
            if i.length and i.charAt(0) == "*"
                [title, url] = i.replace(/(^\*\s+\[)|(\)|]$)/g, '').split("](")
                title = $.escape title
                if url
                    url = $.escape url
                if line.charAt(0) == "*"
                    SUMMARY.push([[title, url]])
                    if count
                        last = SUMMARY[count-1]
                        last.push li
                    li = []
                    ++ count
#                    ++ count
                else
                    r = [title]
                    if url
                        r.push url.slice(0,-3)
                    li.push r
        if count
            SUMMARY[count-1].push li
#        SUMMARY = _.html()
        {
            ... SITE
            hostname:location.hostname.toUpperCase()
        }
    func:
        menu : ->
            System.import('coffee/_site/index/menu').then (m)=>m()
    mounted:->
        page = $("#Page")

        _ = $.html()
        section = "section"
        for [[title, url], post_li],pos in SUMMARY
            if not url
                url = "_"+pos
            url = "-S-"+url
            polen = post_li.length
            if polen
                X = " X"
            else
                X = ""
            _ """<#{section} id="#{url}" class=bar><a href="##{url}">#{title}</a><div class="R split"><i class="I I-close IBtn#{X}"></i></div></#{section}>"""
            _ """<div class=poLi"""
            if polen
                _ ">"
                for [title, url] in post_li
                    if url
                        a = """<a href="/-/#{url}">#{title}</a>"""
                    else
                        a = title
                     _ """<div class=li><div class=title>#{a}</div></div>"""
            else
                _ """ style="display:none">"""
                _ """<div class=li><div class="TC title">暂无</div></div>"""
            _ """</div>"""
        SUMMARY = []
        page.find(".MB90").html _.html()


        $.topfix(page, ".Ptop", '.Pbody')

        page.find('section.bar .I-close').click ->
            jq = $ @
            X = 'X'
            po_li = $(@parentNode.parentNode).next('.poLi').stop()
            if jq.hasClass X
                jq.removeClass X
                s = 'Up'
            else
                jq.addClass X
                s = 'Down'
            po_li['slide'+s](100)


        return
}

</script>
