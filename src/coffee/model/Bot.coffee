module.exports = class
  generator: null
  constructor: (@colour)->
    @init()
  init: ->
  main: (grid)->return null
  @fromString: (codeText, BotClass, HexClass, BridgeClass) ->
    try
      ret = new Function(
        'Bot',
        'Hex',
        'Bridge',
        codeText
      )(
        BotClass,
        HexClass,
        BridgeClass,
      )
    catch e
      return [
        "Error executing Bot"
        e
      ]

    if typeof ret is 'function'
      try
        test = new ret()
      catch e
        return [
          "Error instantiating Bot"
          e
        ]
      if test instanceof BotClass
        return ret
      else
        return [
          'Invalid Bot (Must be an instance of \'Bot\')'
        ]
    else
      return [
        'Invalid Bot (Must be a class extending \'Bot\')'
    ]
