module.exports = (view) ->
  #Restart Button
  $('#RestartGame').click ({target})->
    view.restart()

  #Play Button
  $('#TogglePlay').click ({target})->
    if $(target).html() is 'play_arrow'
      $(target).html 'pause'
      view.running = true
    else
      $(target).html 'play_arrow'
      view.running = false

  #Step Button
  $('#Step').click ({target})->
    unless view.running or view.won
      view.model.step()

  #Autorestart
  $('#AutoRestart').click ({target})->
    if $(target).hasClass 'checked'
      $(target).removeClass 'checked'
      view.autorestart = false
    else
      $(target).addClass 'checked'
      view.autorestart = true

  #Apply buttons
  for button in $ '.editorapply'
    $(button).click ({target})->
      if $(target).hasClass 'red'
        view.applyBots(['red'])
      if $(target).hasClass 'blue'
        view.applyBots(['blue'])

  #Reset buttons
  for button in $ '.editorreset'
    $(button).click ({target})->
      if $(target).hasClass 'red'
        view.resetBots(['red'])
      if $(target).hasClass 'blue'
        view.resetBots(['blue'])

  #Speed Slider
  toDelay = (target)->
    v = +target.val()
    v /= target.attr('max')
    v = 1 - v
    v *= target.attr('max')
    return v
  view.delay = toDelay $('#SpeedSlider')
  $('#SpeedSlider').on 'change', ({target}) ->
    view.delay = toDelay $(target)
