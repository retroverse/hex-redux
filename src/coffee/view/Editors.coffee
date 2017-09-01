module.exports = ->
  #Require Brace (Browserify Ace)
  ace = require 'brace'
  require('brace/mode/javascript')
  require('brace/theme/dawn')
  range = require('../../js/range.js')

  #Default Bot
  defaultbot = """
    return class RedBot extends Bot {
        main(grid) {
            // Get all hexs
            let all = grid.all()

            // Filter for those that are empty
            let empty = all.filter(grid.is_empty)

            // Use lodash to get a random one
            return _.sample(empty)
        }
    }
  """

  #Create Editors
  editors = []
  for editor, i in $('.editortext')
    e = ace.edit editor
    e.getSession().setMode 'ace/mode/javascript'
    e.session.$worker.send("changeOptions", [{asi: true}]);
    e.setTheme 'ace/theme/dawn'
    e.$blockScrolling = Infinity
    e.setShowPrintMargin(false);

    #Set Default Value
    if i is 0
      e.setValue(defaultbot, -1)
    else
      e.setValue(defaultbot.replace("Red", "Blue"), -1)

    #Sets colour
    e.colour = if i is 0 then 'red' else 'blue'

    editors.push e

  checkPersistence = (persistence)->
    for e, i in this.editors
      if persistence.get(i)
        e.setValue(persistence.get(i), -1)

  transformText = (text)->
    text = text.replace /\$\.?([a-zA-Z_$][a-zA-Z_$0-9]*)/g, 'this.$1'
    text = text.replace /export/g, 'return'

  getCode = (i)->
    i = if i is 'red' then 0 else 1
    return transformText this.editors[i].getValue()

  return {
    editors,
    getCode,
    checkPersistence,
    defaultbot,
  }
