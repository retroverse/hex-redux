Hex = require './Hex'
GridProto = require('./lib/Grid')
GridPathFindingProto = require('./lib/GridPF')

class Grid
  constructor: ()->
    #Define State
    @state = []
    for i in [0...11]
      @state[i] = []
      for j in [0...11]
        @state[i][j] = new Hex i, j, { value: 'neutral' }

    #Intialise Path Finding
    @initPathFinding()

  restart: ->
    for row in @state
      for hex in row
        hex.value = 'neutral'

  place: (x, y, val)->
    unless 0<=x<=10 and 0<=y<=10
      console.warn 'Invalid Arguments (Out of Range)'
      return
    node = @state[x][y]
    if node
      if node.value is 'neutral'
        node.value = val
        return true
    else
      console.warn 'Invalid Arguments (No Such Node)'
      return

#Prototype
GridProto(Grid)

#Pathfinding Prototype
GridPathFindingProto(Grid)

module.exports = Grid
