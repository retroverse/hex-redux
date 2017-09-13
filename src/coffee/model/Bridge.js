const _ = require('lodash')

class Bridge {
  constructor (start, end) {
    if (this.constructor.is(start, end)) {
      this.start = start
      this.end = end
    } else {
      throw new Error('Positions arent a bridge')
    }
  }

  positions (grid) {
    return _.intersection(
      grid.neighbours(this.start),
      grid.neighbours(this.end)
    )
  }

  static is (h1, h2) {
    // Ensure that h1 has lowest x
    if (h2.x < h1.x) {
      [h1, h2] = [h2, h1]
    }

    // Get difference
    let dx = h2.x - h1.x
    let dy = h2.y - h1.y

    return (dx === 1 && dy === -2) ||
           (dx === 2 && dy === -1) ||
           (dx === 1 && dy === 1)
  }
}

module.exports = Bridge
