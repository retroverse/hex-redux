require('./jQuery')

###
TODO:
- fix UIControls

###

module.exports = (model)->
  Editors = require('./Editors')
  Notifications = require('./Notifications')
  UIControls = require('./UIControls')
  Persistence = require('./Persistence')
  Statistics = require('./Statistics')
  Grid = require('./Grid')

  view =
    model: model
    notifications: Notifications()
    editors: Editors()
    persistence: new Persistence
    statistics: new Statistics
    grid: new Grid '#hex-grid'

    running: true
    won: false
    autorestart: false
    delay: 20

  #Initialize Editors
  view.controls = UIControls(view)
  view.persistence.init()
  view.editors.checkPersistence view.persistence

  #Callbacks
  view.applyBots = (which)->
    for team in which
      @statistics.reset team
      @notifications.clear team
      code = @editors.getCode team
      bot = @model.Bot.fromString code, @model.Bot, @model.Hex
      if bot instanceof Array
        if bot[1]
          view.error("Construction Error: #{bot[0]}", bot[1], team)
        view.error('Construction Error', bot[0], team)
      else
        $(".botname.#{team}").html(
          bot.name
        )
        @model.setBot(team, bot)
        @persistence.save team,


  view.resetBots = (which)->
    for team in which
      @persistence.clear(team)
      editor = @editors.editors[if team is 'red' then 0 else 1]
      editor.setValue(@editors.defaultbot, -1)
    view.applyBots(which)

  view.play = ->
    $('#TogglePlay').html 'pause'
    view.running = true
    view.notifications.clear()

  view.updateStats = (which)->
    for team in which
      avTime = @statistics.getAverageTime team
      wins = @statistics.getWins team
      $(".stats.#{which} > #Time > .then").html avTime + 's'
      $(".stats.#{which} > #Wins > .then").html wins

  view.pause = ->
    $('#TogglePlay').html 'play_arrow'
    view.running = false

  view.error = (title, message, which) ->
    view.notifications.post(title, message, which)
    view.pause()

  view.warn = (title, which) ->
    view.notifications.post("Warning", title, which)

  view.loop = ->
    if @running and not @won
      # Perform engine step and measure how long it takes
      @statistics.measure @model.activeBot, => @model.step()
      @updateStats([model.activeBot])
    setTimeout(@loop.bind(@), @delay)

  #Load bots now!
  view.applyBots(['red', 'blue'])

  #Callbacks
  view.restart = ()->
    view.notifications.clear()
    @model.restart()
    @grid.onRestart()
    setTimeout(
      (()->@won=false).bind(@),
      190
    )

  view.onTake = (x, y, v) ->
    view.grid.onHexChange x, y, v

  view.onWin = (who, path, state) ->
    @won = true

    #Title Colour and Flash
    $('.title').removeClass "red"
    $('.title').removeClass "blue"
    $('.title').addClass "#{who}"
    $('.title').css("opacity", "0.4")
      .transition({ opacity: "1"}, 1000)

    @grid.onWin(path, state)

    @statistics.recordWin who
    @updateStats([who])

    #Automatically Restart the game
    if @autorestart
      setTimeout @restart.bind(@), 500

  view.model.onWin = view.onWin.bind(view)
  view.model.onTake = view.onTake.bind(view)
  view.model.error = view.error
  view.model.warn = view.warn

  #Start The Loop
  view.loop()

  return view
