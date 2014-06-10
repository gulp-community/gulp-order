through = require "through"
minimatch = require "minimatch"
path = require "path"

module.exports = (patterns = [], options = {}) ->
  files = []
  
  onFile = (file) -> files.push file
  
  relative = (file) ->
    if options.base?
      path.relative options.base, file.path
    else
      file.relative

  rank = (s) ->
    for pattern, index in patterns
      return index if minimatch s, pattern

    return patterns.length

  onEnd = ->
    files.sort (a, b) ->
      aIndex = rank relative a
      bIndex = rank relative b

      if aIndex is bIndex
        String(relative a).localeCompare relative b
      else
        aIndex - bIndex

    files.forEach (file) =>
      @emit "data", file

    @emit "end"

  through onFile, onEnd
