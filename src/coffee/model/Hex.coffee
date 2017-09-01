module.exports = class
  constructor: (@x, @y, {@value}={})->
    @edgeConnections = {
      left: false
      right: false
      top: false
      bottom: false
    }
