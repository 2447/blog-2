
marked = require('coffee/_lib/_marked')
marked.setOptions({
  renderer: new marked.Renderer()
  gfm: true
  tables: true
  breaks:true
  smartLists: true
})
module.exports = marked
