#Require Brace (Browserify Ace)
ace = require 'brace'
require('brace/mode/javascript')
require('brace/theme/dawn')

#Default Bot
defaultbot = """
    class RedBot extends Player {
        main(grid) {
            return new Hex(
                Math.random()*11,
                Math.random()*11
            )
        }
    }
"""

#Create Editors
editors = []
for editor, i in $('.editortext')
  e = ace.edit editor
  e.getSession().setMode 'ace/mode/javascript'
  e.setTheme 'ace/theme/dawn'
  e.$blockScrolling = Infinity

  #Set Default Value
  if i is 0
    e.setValue(defaultbot, -1)
  else
    e.setValue(defaultbot.replace("Red", "Blue"), -1)

  #Sets colour
  e.colour = if i is 0 then 'red' else 'blue'

  editors.push e

#Setup apply buttons
for button in $ '.editorapply'
  $(button).click ({target})->
    if $(target).hasClass 'red'
      engine.persistence.save(0, engine.ace)
      engine.ace.setClass(0)
    if $(target).hasClass 'blue'
      engine.persistence.save(1, engine.ace)
      engine.ace.setClass(1)

#Setup reset buttons
for button in $ '.editorreset'
  $(button).click ({target})->
    if $(target).hasClass 'red'
      engine.persistence.clear('red')
      for editor, i in engine.ace.editors
        v = defaultbot
        if i is 0 then editor.setValue(v, -1)
    if $(target).hasClass 'blue'
      engine.persistence.save('blue')
      for editor, i in engine.ace.editors
        v = defaultbot.replace("Red", "Blue")
        if i is 1 then editor.setValue(v, -1)

setClass = (i)->
  cl = this.getClass(i)
  if cl
    col = if i is 0 then 'red' else 'blue'
    engine.setPlayer(col, cl)

checkPersistence = (persistence)->
  for e, i in this.editors
    #Check for persistence
    if persistence.get(i)
      e.setValue(persistence.get(i), -1)


getClass = (i)->
  editor = this.editors[i]
  codeText = editor.getValue()
  try
    ret = eval(codeText)
  catch e
    console.warn "Error executing Bot"
    console.warn e
    return

  if typeof ret is 'function'
    try
      test = new ret()
    catch e
      console.warn "Error instantiating Bot"
      console.warn e
      return
    if test instanceof Player
      return ret
    else
      console.warn 'Invalid Bot (Must be instance of \'Player\')'
  else
    console.warn 'Invalid Bot (Must be a class extending \'Player\')'

module.exports = {
  editors,
  getClass,
  setClass,
  checkPersistence
}
