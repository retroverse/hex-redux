class Grid
  constructor: (selector)->
    #Get the root node
    @root = $(selector)

    #Create state skeleton
    @state = []
    for i in [0...11]
      @state[i] = []
      for j in [0...11]
        @state[i][j] = null

    #Fill skeleton
    for i in [0...11]
      @root.append row = $('<div class="hex row neutral"></div>')
      for j in [0...11]
        row.append cell = $('<div class="hex cell neutral"></div>')
        @state[j][i] = cell

  onHexChange: (x, y, v)->
    ell = $ @state[y][x]

    #Update Looks
    ell.removeClass('neutral')
    ell.removeClass('red')
    ell.removeClass('blue')
    ell.addClass(v)

  onRestart: ->
    for column in @state
      for element in column
        ell = $(element)
        ell.addClass('neutral')
        ell.removeClass('red')
        ell.removeClass('blue')
        ell.transition({opacity: "1"}, 200)

  onWin: (path, state)->
    pathHexs = []
    for row in state
      for hex in row
        for p in path
          if p[0] is hex.y and p[1] is hex.x
            pathHexs.push hex

    #Dim non-path hex's
    for row in state
      for hex in row
        unless pathHexs.includes hex
          $(@state[hex.x][hex.y]).transition({ opacity: ".4"}, 350)

module.exports = Grid
