Hex = require './Hex'
GridProto = require('./lib/Grid')
GridPathFindingProto = require('./lib/GridPF')

grid = class
  constructor: (selector, @size=11)->
    #Define State
    @state = []
    for i in [0...@size]
      @state[i] = []
      for j in [0...@size]
        @state[i][j] = new Hex i, j, { value: 'neutral' }

    #Intialise Path Finding
    @initPathFinding()

    #Get the root node
    @root = $(selector)

    #Add rows
    for i in [0...@size]
      @root.append row = $('<div class="hex row"></div>')
      for j in [0...@size]
        row.append cell = $('<div class="hex cell"></div>')
        @state[i][j].element = cell

  restart: ->
    for row in @state
      for hex in row
        hex.value = 'neutral'
        $(hex.element).transition({opacity: "1"}, 200)

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

  update: (which)->
    #Update Looks
    $('.hex.cell').removeClass('neutral')
    $('.hex.cell').removeClass('red')
    $('.hex.cell').removeClass('blue')

    for row in @state
      for hex in row
        $(hex.element).addClass(hex.value)

#Prototype
GridProto(grid)

#Pathfinding Prototype
GridPathFindingProto(grid)

module.exports = grid
