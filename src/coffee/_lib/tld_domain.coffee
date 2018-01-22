do ->
  i = 0
  domain = document.domain
  p = domain.split('.')
  now = new Date()
  s = now.getTime()
  now.setTime(s+999)
  v = '_' + s + '=' + s
  while i < p.length - 1 and document.cookie.indexOf(v) == -1
    domain = p.slice(-1 - ++i).join('.')
    document.cookie = v + ';expires='+ now.toUTCString() + ';domain=' + domain + ';'
  document.domain = domain
  return
