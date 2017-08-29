$ ->
  #Play Button
  $('#TogglePlay').click ({target})->
    if $(target).html() is 'play_arrow'
      $(target).html 'pause'
      engine.running = true
    else
      $(target).html 'play_arrow'
      engine.running = false

  #Step Button
  $('#Step').click ({target})->
    unless engine.running or engine.won
      engine.update()

  #Autorestart
  $('#AutoRestart').click ({target})->
    if $(target).hasClass 'checked'
      $(target).removeClass 'checked'
      engine.autorestart = false
    else
      $(target).addClass 'checked'
      engine.autorestart = true

  #Speed Slider
  engine.loopDelay = $('#SpeedSlider').value
  $('#SpeedSlider').mousedown ({target})->
    engine.paused = true
  $('#SpeedSlider').mouseup ({target})->
    engine.paused = false
  $('#SpeedSlider').on 'change', ({target}) ->
    v = target.value
    v /= target.max
    v = 1 - v
    v *= target.max
    engine.loopDelay = v
