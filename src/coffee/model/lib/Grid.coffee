Hex = require '../Hex'
_ = require 'lodash'

module.exports = (grid)->
  grid.prototype.clone = ->
    o = _.cloneDeep @
    o.bindToSelf o
    return o

  #Gets a hex from a set point
  grid.prototype.get = (x, y, isSilent)->
    if x instanceof Hex then return x
    unless 0 <= x <= 10 and 0 <= y <= 10
      unless isSilent then throw new Error "Attempting to 'get', out of range at [#{x}, #{y}]"
      return null
    hex = this.state[x][y]
    if hex
      return hex

  #Returns whether a hex is empty
  grid.prototype.is_empty =
  grid.prototype.is_neutral = (h, y)->
    if this instanceof grid then h = this.get(h, y)
    h.value is 'neutral'

  #Returns whether a hex is empty
  grid.prototype.is_taken = (h, y)->
    if this instanceof grid then h = this.get(h, y)
    h.value isnt 'neutral'

  #Returns whether a hex is red
  grid.prototype.is_red = (h, y)->
    if this instanceof grid then h = this.get(h, y)
    h.value is 'red'

  #Returns whether a hex is blue
  grid.prototype.is_blue = (h, y)->
    if this instanceof grid then h = this.get(h, y)
    h.value is 'blue'

  #Returns whether two given hex's are opposites
  grid.prototype.is_opposite = (h, o)->
    if h.value is 'neutral' then return false
    return h.value isnt o.value

  #Returns every hex in the grid
  grid.prototype.all = ->
    hexs = []
    for column in this.state
      for row in column
        hexs.push row
    return hexs

  #Returns all of a hex's neighbours
  grid.prototype.neighbours = (h)->
    neighbours = []
    for i in [-1, 0, 1]
      for j in [-1, 0, 1]
        unless (i is 0 and j is 0) or i is j
          if 0 <= h.x+i <= 10
            if 0 <= h.y+j <= 10
              n = this.get(h.x + i, h.y + j, true) ## Silently cancel on null hex
              if n then neighbours.push n
    return neighbours

  #Gets whether two hex's are neighbours
  grid.prototype.is_neighbour = (x1, y1, x2, y2)->
    for hex in this.neighbours x1, y1
      if hex.x is x2 and hex.y is y2
        return true
    return false

  #Returns all hex's in a row
  grid.prototype.row = (y)->
    this.get(x, y) for x in [0...11]

  #Returns all hex's in a column
  grid.prototype.column = (x)->
    this.get(x, y) for y in [0...11]

  #Centralized Hex methods (for mapping)
  grid.prototype.bindToSelf = () ->
    for key of @
      if typeof @[key] is 'function'
        @[key] = @[key].bind @
