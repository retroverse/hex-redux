Grid = require('./Grid')
unless window.grid
  window.grid = new Grid '#hex-grid'
  window.grid.update()
