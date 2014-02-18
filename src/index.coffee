through = require "through"
minimatch = require "minimatch"

module.exports = (patterns = []) ->
  files = []
  
  onFile = (file) -> files.push file

  rank = (s) ->
    for pattern, index in patterns
      return index if minimatch s, pattern

    return patterns.length

  onEnd = ->
    files.sort (a, b) ->
      aIndex = rank a.relative
      bIndex = rank b.relative

      if aIndex is bIndex
        String(a.relative).localeCompare b.relative
      else
        aIndex - bIndex

    files.forEach (file) =>
      @emit "data", file

    @emit "end"

  through onFile, onEnd
