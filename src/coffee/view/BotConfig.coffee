module.exports =
  update: (ace)->
    for editor, i in ace.editors
      title = $ ".editortitle.#{editor.colour}"
      className = engine.bots[editor.colour].constructor.name
      if className
        title.html className
      else
        str = editor.colour
        str = editor.colour.slice(1)
        str = editor.colour.charAt(0).toUpperCase() + str
        title.html "#{str}Bot"
