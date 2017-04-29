#Require Jquery for getting editors
$ = require 'jquery'

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

  if i is 0
    e.setValue(defaultbot, -1)
  else
    e.setValue(defaultbot.replace("Red", "Blue"), -1)

  e.colour = if i is 0 then 'red' else 'blue'

  editors.push e

#Setup apply buttons
for button in $ '.editorapply'
  $(button).click ({target})->
    if $(target).hasClass 'red'
      engine.ace.setClass(0)
    if $(target).hasClass 'blue'
      engine.ace.setClass(1)

setClass = (i)->
  cl = this.getClass(i)
  if cl
    col = if i is 0 then 'red' else 'blue'
    engine.setPlayer(col, cl)


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
  setClass
}
