module.exports = (grid)->
  #Gets a hex from a set point
  grid.prototype.get = (x, y)->
    hex = this.state[x][y]
    if hex
      return hex

  #Returns whether a hex is empty
  grid.prototype.is_empty = (h)->
    h.value is 'neutral'

  grid.prototype.is_neutral = grid.prototype.is_empty

  #Returns whether a hex is red
  grid.prototype.is_red = (h)->
    h.value is 'red'

  #Returns whether a hex is blue
  grid.prototype.is_red = (h)->
    h.value is 'blue'

  grid.prototype.all = ->
    hexs = []
    for column in this.state
      for row in column
        hexs.push row
    return hexs

  #Returns all of a hex's neighbours
  grid.prototype.neighbours = (x, y)->
    neighbours = []
    for i in [-1, 0, 1]
      for j in [-1, 0, 1]
        unless (i is 0 and j is 0) or i is j
          if 0 <= x+i <= 10
            if 0 <= y+j <= 10
              neighbours.push this.state[x+i][y+j]
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
