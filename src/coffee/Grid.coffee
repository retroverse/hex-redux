$ = require 'jquery'
Hex = require './Hex'

module.exports = class
  constructor: (@selector, @size=11)->
    #Define State
    @state = []
    for i in [0...@size]
      @state[i] = []
      for j in [0...@size]
        @state[i][j] = new Hex {
          x: i
          y: j
          value:
            if Math.round(Math.random(1)) then 'blue' else
              if Math.round(Math.random(1)) then 'red' else 'neutral'
        }

    #Get the root node
    root = $(@selector)

    #Add rows
    for i in [0...@size]
      root.append row = $('<div class="hex row"></div>')
      for j in [0...@size]
        row.append col = ('<div class="hex cell"></div>')

  update: ->
    i = j = 0
    for row in  $('.hex.row')
      for hex in $(row).children()
        value = @state[i][j].value
        $(hex).removeClass('neutral')
        $(hex).removeClass('red')
        $(hex).removeClass('blue')
        $(hex).addClass(value)
        j++
      j = 0
      i++
    #For each Row
      #For each column
        #Check state
        #update classes
