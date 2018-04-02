through = require "through"
{ Minimatch } = require "minimatch"
path = require "path"
sort = require "stable"

module.exports = (patterns = [], options = {}) ->
  files = []

  matchers = patterns.map (pattern) ->
    if pattern.indexOf("./") is 0
      throw new Error "Don't start patterns with `./` - they will never match. Just leave out `./`"

    Minimatch pattern

  onFile = (file) -> files.push file

  relative = (file) ->
    if options.base?
      path.relative options.base, file.path
    else
      file.relative

  rank = (matchers, file) ->
    relativePath = relative file
    for matcher, index in matchers
      return index if matcher.match relativePath

    return matchers.length

  onEnd = ->
    sort.inplace files, (a, b) ->
      ranker = options.rank || rank
      aIndex = ranker(matchers, a)
      bIndex = ranker(matchers, b)

      if aIndex is bIndex
        String(relative a).localeCompare relative b
      else
        aIndex - bIndex

    files.forEach (file) =>
      @emit "data", file

    @emit "end"

  through onFile, onEnd
