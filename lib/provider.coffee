# return array of all possible completions for the given node package
generatePackageCompletions = (packageName) ->
  try
    pkg = require packageName
    return Object.keys(pkg)
  catch error
    return null

module.exports =
  # This will work on JavaScript and CoffeeScript files, but not in js comments.
  selector: '.source.js, .source.coffee'
  disableForSelector: '.source.js .comment'

  # This will take priority over the default provider, which has a priority of 0.
  inclusionPriority: 1

  addCompletions: (pkg, completions) ->
    return unless completions
    @completions[pkg] = completions
    console.log "added #{completions.length} completions for '#{pkg}'"

  loadCompletions: ->
    @completions = {}
    for pkg in ['fs', 'path', 'assert', 'http', 'os']
      @addCompletions pkg, generatePackageCompletions(pkg)
    return

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
    [varName, prefix] = @getPrefix(editor, bufferPosition)
    if @completions[varName]?
      return @getPackageCompletions(varName, prefix)
    else
      match = editor.getText().match "#{varName}\\s+=\\s+require[ \\(]'(\\w+)'"
      if match?
        moduleName = match[1]
        @addCompletions(varName, generatePackageCompletions(moduleName))
        return @getPackageCompletions(moduleName, prefix)
      return []

