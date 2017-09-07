Grid = require('./Grid')
Bot = require('./Bot')
Hex = require('./Hex')
_ = require('lodash')

module.exports = class
  constructor: ()->
    @grid = new Grid()
    @bots =
      red: new Bot 'red'
      blue: new Bot 'blue'
    @activeBot = 'red'

    @Hex = Hex
    @Bot = Bot
    @Grid = Grid

    @onWin = (who, path, state) ->
    @onTake = (x, y, c) ->
    @warn = (x, which) -> console.warn x
    @error = (x, err, which) -> console.warn x, err

  win: (who, path)->
    unless @won
      @won = true
    @onWin who, path, @grid.state

  restart: ->
    @grid.restart()
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
    @bots[which] = new bot which

  resetBot: (which)->
    @bots[which] = new @bots[which].constructor which

  iterateGenerator: (active)->
    yielded = active.generator.next({
      grid: _.cloneDeep @grid, true
      succesfull: active.generator.previousSuccesfull
    })
    active.generator.previousSuccesfull = false
    if yielded.done
      @warn('Generator ended early, perhaps add a while loop?', @activeBot)
    return yielded.value

  step: ->
    #Bot whos turn it is
    active = @bots[@activeBot]

    if active.generator
      #Iterate Generator
      try
        returned = @iterateGenerator(active)
      catch e
        @error('Bot encounted a runtime error. ', e, @activeBot)
    else
      #Perform Turn
      g = _.cloneDeep @grid
      g.bindToSelf()
      try
        returned = active.main g
      catch e
        @error('Bot encounted a runtime error. ', e, @activeBot)

    #Check if returned is a generator
    if typeof returned is 'function'
      active.generator = returned(_.cloneDeep @grid, true)
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
        @onTake x, y, @activeBot
        @swapActiveBot()
        #Tell Generator it Worked
        if active.generator
          active.generator.previousSuccesfull = true
    else
      @warn "Incorrect Bot Return of #{returned} (Not Instance of Hex)"
