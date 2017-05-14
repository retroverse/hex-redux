class Persistence
  available: false
  getAvailable: (type)->
    try
      storage = window[type]
      x = '__storage_test__'
      storage.setItem x, x
      storage.removeItem x
      return true
    catch e
      return e instanceof DOMException and (
        e.code is 22 or
        e.code is 1014 or
        e.name is 'QuotaExceededError' or
        e.name is 'NS_ERROR_DOM_QUOTA_REACHED') and
        storage.length isnt 0
  init: ->
    this.available = this.getAvailable('localStorage')

  clear: (which)->
    if this.available
      if which is 'red'
        localStorage.removeItem('hex-bot-red')
        return
      if which is 'blue'
        localStorage.removeItem('hex-bot-blue')
        return
      localStorage.removeItem('hex-bot-blue')
      localStorage.removeItem('hex-bot-red')


  get: (which)->
    if this.available
      col = if which is 0 then 'red' else 'blue'
      key = "hex-bot-#{col}"
      return localStorage.getItem(key)
    return undefined

  save: (which, brace)->
    if this.available
      val = brace.editors[which].getValue()
      col = if which is 0 then 'red' else 'blue'
      key = "hex-bot-#{col}"
      localStorage.setItem(key, val)

##Export
module.exports = Persistence
