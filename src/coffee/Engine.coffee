BotConfig = require('./BotConfig')
Grid = require('./Grid')
Player = require('./Player')
Hex = require('./Hex')
_ = require('lodash')

module.exports = class
  constructor: (grid_selector, ace)->
    @grid = new Grid grid_selector
    @grid.win = @win.bind(this)
    @players =
      red: new Player
      blue: new Player
    @activePlayer = 'red'
    @updateDelay = 0
    @running = true
    @ace = ace

  win: (who, hex)->
    if @running
      console.log "#{who} has won!"
      @running = false

  restart: ->
    @grid.restart()
    @running = true

  swapActivePlayer: ->
    if @activePlayer is 'red'
      @activePlayer = 'blue'
    else
      @activePlayer = 'red'

  setPlayer: (which, player)->
    @players[which] = new player

  update: ->
    if @running
      #Player whos turn it is
      active = @players[@activePlayer]

      #Perform Turn
      returned = active.main _.clone @grid.state, true
      if returned instanceof Hex
        #Get Value from Returned
        {x, y} = returned

        #Attempt to take spot, if succesfull swap players
        if @grid.place x, y, @activePlayer
          @swapActivePlayer()
      else
        console.warn('Incorrect Player Return (Not Instance of Hex)')

    #Update The Grid Visuals
    @grid.update()

    #Update Bot Configurations
    BotConfig.update @ace

    #Call me again
    setTimeout(@update.bind(this), @updateDelay)
