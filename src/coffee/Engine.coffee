BotConfig = require('./BotConfig')
Grid = require('./Grid')
Player = require('./Player')
Hex = require('./Hex')
Persistence = require('./Persistence')
_ = require('lodash')

module.exports = class
  constructor: (grid_selector, ace)->
    @grid = new Grid grid_selector
    @grid.win = @win.bind(this)
    @players =
      red: new Player
      blue: new Player
    @activePlayer = 'red'
    @loopDelay = 0
    @running = true
    @ace = ace
    @persistence = new Persistence
    @persistence.init()
    @ace.checkPersistence(@persistence)

  win: (who, hex)->
    if @running
      @running = false
      console.log "#{who} has won!"
      $('.title').removeClass "red"
      $('.title').removeClass "blue"
      $('.title').addClass "#{who}"
      $('.title').css("opacity", "0.4")
        .transition({ opacity: "1"}, 1000);

  restart: ->
    @grid.restart()
    @running = true
    @resetPlayer('red')
    @resetPlayer('blue')
    @activePlayer = 'red'

  swapActivePlayer: ->
    if @activePlayer is 'red'
      @activePlayer = 'blue'
    else
      @activePlayer = 'red'

  setPlayer: (which, player)->
    @players[which] = new player

  resetPlayer: (which)->
    @players[which] = new @players[which].constructor

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
    if @running
      @update()

    #Update The Grid Visuals
    @grid.update()

    #Update Bot Configurations
    BotConfig.update @ace

    #Call me again
    setTimeout(@loop.bind(this), @loopDelay)

  update: ->
    #Player whos turn it is
    active = @players[@activePlayer]

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

      #Attempt to take spot, if succesfull swap players
      if @grid.place x, y, @activePlayer
        @swapActivePlayer()
        #Tell Generator it Worked
        if active.generator
          active.generator.previousSuccesfull = true
    else
      console.warn('Incorrect Player Return (Not Instance of Hex)')
