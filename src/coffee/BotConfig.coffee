$ = require 'jquery'

module.exports =
  update: (ace)->
    for editor, i in ace.editors
      title = $ ".editortitle.#{editor.colour}"
      text = editor.getValue()
      name = text.replace(/class\s+(.*)\s+extends[\s\S]*/, "$1")
      if text isnt name and not /$\s*^/.test name
        title.html name
      else
        str = editor.colour
        str = editor.colour.slice(1)
        str = editor.colour.charAt(0).toUpperCase() + str
        title.html "#{str}Bot"
