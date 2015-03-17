# return array of all possible completions for the given node package
generatePackageCompletions = (packageName) ->
  pkg = require packageName
  return Object.keys(pkg)

module.exports =
  # This will work on JavaScript and CoffeeScript files, but not in js comments.
  selector: '.source.js, .source.coffee'
  disableForSelector: '.source.js .comment'

  # This will take priority over the default provider, which has a priority of 0.
  inclusionPriority: 1

  loadCompletions: ->
    @completions = {}
    for pkg in ['fs', 'path', 'assert', 'http', 'os']
      @completions[pkg] = generatePackageCompletions(pkg)
    console.log @completions

  getPrefix: (editor, bufferPosition) ->
    # Get the text for the line up to the triggered buffer position
    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
    # Match the regex to the line, and return the match
    /([\w\d_]+)\.([\w\d_]*)$/.exec(line)?.slice(1) or []

  getPackageCompletions: (name, prefix = '') ->
    return [] unless @completions[name]
    for fn in @completions[name] when fn.indexOf(prefix) is 0
      {text: fn, rightLabel: name, replacementPrefix: prefix}

  # Required: Return a promise, an array of suggestions, or null.
  getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
    [moduleName, prefix] = @getPrefix(editor, bufferPosition)
    return @getPackageCompletions(moduleName, prefix)
