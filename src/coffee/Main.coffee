window.Ace = require('./Brace')
Engine = require('./Engine')

#engine only global for testing
unless window.engine
  window.engine = new Engine '#hex-grid'

#Global Class Access
window.Player = require('./Player')
window.Hex = require('./Hex')

class Random extends Player
  main: (grid)->
    new Hex Math.round(Math.random()*10),
      Math.round(Math.random()*10)

window.engine.setPlayer('red', Random)
window.engine.setPlayer('blue', Random)
window.engine.update()
