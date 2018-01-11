
module.exports = (size) ->
    i = Math.floor( Math.log(size) / Math.log(1024) )
    return ( size / Math.pow(1024, i) ).toFixed(2) * 1 + ' ' + ['B', 'KB', 'M', 'G', 'T'][i]
