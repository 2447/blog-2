<style scoped lang="scss">
header {
    margin:0 auto 64px;
    padding:39px 0 55px;
    background:#fdfdfd;
    box-shadow: 0 0 8px #eee inset;
    border-bottom:1px dashed #eee;
    text-align:center;
    h1{
        margin-bottom:0;
        letter-spacing: 2px;
    }
    h2{
        margin-top:0;
    }
}
</style>


<template lang="slm">
form#PBY v-on:submit.prevent="submit"
    header
        .Pbk
            h1 八卦博客
            h2 8GUA.BLOG
            p 您好！第一次使用？请先阅读
            p
                a.btn.ghost href="/help" 帮助文档
    .Form.Pbk
        .P
            h1
                | 站名
                .tip 必填
            input  v-model.trim="name" autocomplete="off" placeholder="首先要有光 …"
        .P
            h1
                | 标语
            input v-model.trim="slogan" autocomplete="off" placeholder="一句话简介 …"
        input.btn type="submit" value="生成站点"

    slm:
        util/footer
</template>


<script lang="coffee">
export default {
    func:
        submit : ->
            {name, slogan} = data = @$data
            if name == SITE.name and slogan == SITE.slogan
                GO.push '/'
                return
            key = '/init'
            $.when(
                PP.postJSON(
                    "font#{key}"
                    {
                        H:name+slogan
                    }
                )
                PP.postToml(
                    "-#{key}"
                    data
                )
            ).done =>
                $.box.alert "<h1><p>站点设置保存成功</p><p>字体样式将在十分钟后生效</p></h1>", {
                    ok : ->
                        location.href="/"
                }

    data:'name slogan'
}
</script>
