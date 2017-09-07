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
      localStorage.removeItem("hex-bot-#{which}")


  get: (which)->
    if this.available
      key = "hex-bot-#{which}"
      return localStorage.getItem(key)
    return undefined

  save: (which, code)->
    if this.available
      key = "hex-bot-#{which}"
      localStorage.setItem(key, code)

##Export
module.exports = Persistence
