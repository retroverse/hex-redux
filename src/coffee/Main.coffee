#Styles
require("../sass/Index")

require('./jQuery')
require('./UIControls')
Ace = require('./Brace')
Engine = require('./Engine')
Notifications = require('./Notifications')

#engine only global for testing
unless window.engine
  window.engine = new Engine '#hex-grid', Ace

#Global Class Access
window.Bot = require('./Bot')
window.Hex = require('./Hex')
window.Grid = require('./Grid')
window.Notifications = Notifications
window._ = require('lodash')

#Load Default Bots
engine.ace.setClass(0)
engine.ace.setClass(1)

window.engine.loop()
