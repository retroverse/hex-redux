BotConfig = require('./BotConfig')
Grid = require('./Grid')
Bot = require('./Bot')
Hex = require('./Hex')
Persistence = require('./Persistence')
_ = require('lodash')

module.exports = class
  constructor: (grid_selector, ace)->
    @grid = new Grid()
    @grid.initDOM grid_selector
    @bots =
      red: new Bot
      blue: new Bot
    @activeBot = 'red'
    @loopDelay = 0
    @running = true
    @won = false
    @autorestart = false
    @ace = ace

    @persistence = new Persistence
    @persistence.init()
    @ace.checkPersistence(@persistence)

  win: (who, path)->
    unless @won
      @won = true
      console.log "#{who} has won!"

      #Title Colour and Flash
      $('.title').removeClass "red"
      $('.title').removeClass "blue"
      $('.title').addClass "#{who}"
      $('.title').css("opacity", "0.4")
        .transition({ opacity: "1"}, 1000)

      #First ensure that grid is up-to-date
      @grid.update()

      #Get path hexs
      pathHexs = []
      for row in @grid.state
        for hex in row
          for p in path
            if p[0] is hex.x and p[1] is hex.y
              pathHexs.push hex

      #Dim non-path hex's
      for row in @grid.state
        for hex in row
          unless pathHexs.includes hex
            $(hex.element).transition({ opacity: ".4"}, 350)


      #Automatically Restart the game
      if @autorestart
        setTimeout @restart.bind(this), 400


  restart: ->
    @grid.restart()
    @won = false
    @resetBot('red')
    @resetBot('blue')
    @activeBot = 'red'

  swapActiveBot: ->
    if @activeBot is 'red'
      @activeBot = 'blue'
    else
      @activeBot = 'red'

  updateConnectionsAndCheckWin: ->
    path = @grid.updateConnections(@activeBot)
    if path
      @win @activeBot, path.shortest

  setBot: (which, bot)->
    @bots[which] = new bot

  resetBot: (which)->
    @bots[which] = new @bots[which].constructor

  iterateGenerator: (active)->
    yielded = active.generator.next({
      grid: _.clone @grid, true
      succesfull: active.generator.previousSuccesfull
    })
    active.generator.previousSuccesfull = false
    if yielded.done
      console.warn 'Generator ended early, perhaps add a while loop?'
    return yielded.value

  loop: ->
    if @running and not @won
      @update()

    #Update The Grid Visuals
    @grid.update()

    #Update Bot Configurations
    BotConfig.update @ace

    #Call me again
    setTimeout(@loop.bind(this), @loopDelay)

  update: ->
    #Bot whos turn it is
    active = @bots[@activeBot]

    if active.generator
      #Iterate Generator
      try
        returned = @iterateGenerator(active)
      catch e
        console.warn('Bot encounted a runtime error. ', e)
    else
      #Perform Turn
      try
        returned = active.main _.clone @grid, true
      catch e
        console.warn('Bot encounted a runtime error. ', e)

    #Check if returned is a generator
    if typeof returned is 'function'
      active.generator = returned(_.clone @grid, true)
      returned = @iterateGenerator(active)

    #Assuming Hex
    if returned instanceof Hex
      #Get Value from Returned
      {x, y} = returned

      #Floor Values
      [x, y] = [Math.floor(x), Math.floor(y)]

      #Attempt to take spot, if succesfull swap bots
      if @grid.place x, y, @activeBot
        @updateConnectionsAndCheckWin()
        @swapActiveBot()
        #Tell Generator it Worked
        if active.generator
          active.generator.previousSuccesfull = true
    else
      console.warn('Incorrect Bot Return (Not Instance of Hex)')
