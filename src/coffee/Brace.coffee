#Require Jquery for getting editors 
$ = require 'jquery'

#Require Brace (Browserify Ace)
ace = require 'brace'
require('brace/mode/javascript')
require('brace/theme/dawn')

#Default Bot
defaultbot = """
  class MyBot extends Player {
    main(grid) {
      return new Hex(0, 0)
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
  e.setValue(defaultbot, -1)
  editors.push e

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
    test = new ret
    if test instanceof Player
      return ret
    else
      console.warn 'Invalid Bot (Must be instance of \'Player\')'
  else
    console.warn 'Invalid Bot (Must be a class extending \'Player\')'

module.exports = {
  editors,
  getClass
}
