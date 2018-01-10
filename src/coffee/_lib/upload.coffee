
module.exports = {
    size: (size) ->
        i = Math.floor( Math.log(size) / Math.log(1024) )
        return ( size / Math.pow(1024, i) ).toFixed(2) * 1 + ' ' + ['B', 'KB', 'M', 'G', 'T'][i]

    post: (file, url, callback, page)->
        name = $.escape file.name
        t = $.toast(
            """#{name}<span class="ing"><span class="ed"><span class="num"></span>%</span><span>剩余时间 --:--</span><span>已上传 0</span></span>"""
            {
                close:"取消上传"
                body:page
                timeout:0
            }
        )
        ed = t.find('.ed .num')
        formData = new FormData()
        formData.append('file', file)
        xhr = $.ajaxSettings.xhr()
        $.ajax {
            url
            data: formData
            processData: false
            contentType: false
            type: 'POST'
            # headers:
            #     'X-File-Name': encodeURIComponent(file.name)
            xhr: ->
                xhr.upload.onprogress = (e) =>
                    @progress(e)
                xhr
            progress: (e) =>
                return unless e.lengthComputable
                { loaded } = e
                ed.text (100*loaded/e.total).toFixed(2)
                return
                # @trigger 'uploadprogress', [file, e.loaded, e.total]
            error: (xhr, status, err) =>
                $.toast("""#{name} 上传失败""", {
                    body:page
                    timeout:30
                    close:1
                }).addClass 'ERR'
                return
                # @trigger 'uploaderror', [file, xhr, status]
            success: (result) =>
                callback(file, result)
                return
                # @trigger 'uploadprogress', [file, file.size, file.size]
                # @trigger 'uploadsuccess', [file, result]
                # $(document).trigger 'uploadsuccess', [file, result, @]
            complete: (xhr, status) =>
                t.close()
                return
                # @trigger 'uploadcomplete', [file, xhr.responseText]
        }
        t.find('.I-close').click ->
            if xhr.readyState != 4
                xhr.abort()
            return
        return


}

