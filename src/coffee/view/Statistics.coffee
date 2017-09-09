class Statistics
  constructor: () ->
    @wins =
      red: 0
      blue: 0
    @times =
      red: []
      blue: []
    @averages =
      red: 0
      blue: 0


  reset: (bot)->
    @wins[bot] = 0
    @times[bot] = []
    @averages[bot] = 0

  getAverageTime: (bot) ->
    Math.floor(@averages[bot] * 1000) / 1000

  getWins: (bot) ->
    @wins[bot]

  measure: (bot, func) ->
    start = performance.now()
    func()
    end = performance.now()
    ms = end - start
    scs = Math.floor(ms * 100) / 100000
    @recordTime bot, scs

  recordWin: (bot) ->
    @wins[bot]++

  recordTime: (bot, val) ->
    @times[bot].push val
    @averages[bot] = @times[bot].reduce((a, b) => a + b) / @times[bot].length

module.exports = Statistics
