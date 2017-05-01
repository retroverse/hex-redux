$ = require 'jquery'
Hex = require './Hex'
GridProto = require('./lib/Grid')

grid = class
  constructor: (selector, @size=11)->
    #Define State
    @state = []
    for i in [0...@size]
      @state[i] = []
      for j in [0...@size]
        @state[i][j] = new Hex i, j, { value: 'neutral' }

    #Get the root node
    @root = $(selector)

    #Add rows
    for i in [0...@size]
      @root.append row = $('<div class="hex row"></div>')
      for j in [0...@size]
        row.append col = ('<div class="hex cell"></div>')

  restart: ->
    @state = []
    for i in [0...@size]
      @state[i] = []
      for j in [0...@size]
        @state[i][j] = new Hex i, j, { value: 'neutral' }

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


  updateConnections: ->
    i = j = 0
    for i in [0..10]
      for j in [0..10]
        hex = @state[i][j]
        unless hex.value is 'neutral'
          con = hex.edgeConnections

          #Check For Direct Connection
          if hex.value is 'red'
            if i is 0
              con.left = true
              if con.right
                @win 'red', hex
            if i is 10
              con.right = true
              if con.left
                @win 'red', hex
          if hex.value is 'blue'
            if j is 0
              con.top = true
              if con.bottom
                @win 'blue', hex
            if j is 10
              con.bottom = true
              if con.top
                @win 'blue', hex

          #Flow Through
          for xx in [-1, 0, 1]
            for yy in [-1, 0, 1]
              unless xx is yy
                tx = i+xx
                ty = j+yy
                if -1<tx<11 and -1<ty<11
                  n = @state[tx][ty]
                  if n.value is hex.value
                    ncon = n.edgeConnections
                    if ncon.left then con.left = true
                    if ncon.right then con.right = true
                    if ncon.top then con.top = true
                    if ncon.bottom then con.bottom = true

  update: ->
    #Update Looks
    $('.hex.cell').removeClass('neutral')
    $('.hex.cell').removeClass('red')
    $('.hex.cell').removeClass('blue')

    i = j = 0
    for row in $('.hex.row')
      for hex in $(row).children()
        value = @state[i][j].value
        $(hex).addClass(value)
        i++
      i = 0
      j++

    ##Update Connections
    @updateConnections()

#Prototype
GridProto(grid)

module.exports = grid
