Pathfinding = require('pathfinding')

module.exports = (grid)->
  grid.prototype.initPathFinding = ()->
    #Define Pathfinding Grid
    @pfstate = new Pathfinding.Grid @state
    #Create Finder
    @finder = new Pathfinding.AStarFinder({
        diagonalMovement: Pathfinding.DiagonalMovement.Always
    })

  grid.prototype.hasWon = (which)->
    not not @updateConnections which

  grid.prototype.updateConnections = (which)->
    unless which is 'red' or which is 'blue'
      return

    #Set walkable
    for row in @state
      for hex in row
        @pfstate.setWalkableAt hex.x, hex.y,
          hex.value is which

    #Create Finder
    finder = new Pathfinding.AStarFinder({
        diagonalMovement: Pathfinding.DiagonalMovement.Always
    })

    to = []
    endX = undefined
    endY = undefined
    if which is 'red'
      to = this.column(0).filter(this.is_red)
      endX = 10
      goal = (node)->node.x is endX
    if which is 'blue'
      to = this.row(0).filter(this.is_blue)
      endY = 10
      goal = (node)->node.y is endY

    paths = []
    for hex in to
      path = finder.findPath(hex.x, hex.y, goal, endX, endY, @pfstate.clone())
      if path and path.length > 0
        paths.push path

    if paths.length > 0
      paths.sort (a, b)->a.length - b.length
      return {
        paths,
        shortest: paths[0]
      }

    return false
