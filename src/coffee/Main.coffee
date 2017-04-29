Ace = require('./Brace')
Engine = require('./Engine')

#engine only global for testing
unless window.engine
  window.engine = new Engine '#hex-grid', Ace

#Global Class Access
window.Player = require('./Player')
window.Hex = require('./Hex')

#Load Default Bots
engine.ace.setClass(0)
engine.ace.setClass(1)

window.engine.update()
