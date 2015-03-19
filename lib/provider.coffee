util = require 'util'

getTypeHint = (value) ->
  if util.isString(value) then "'' "
  else if util.isArray(value)  then '[] '
  else if util.isObject(value) then '{} '
  else ''

getFunctionArguments = (func) ->
  # extract arguments from function signature (sneaky JS)
  args = func.toString().match(/\(([^\)]+)\)/)?[1] ? ''
  return args.split(/,\s+/)

# returns array of all possible completions for the given Node package name.
generatePackageCompletions = (packageName) ->
  try
    pkg = require packageName
    for key, val of pkg
      cmp = {text: key, rightLabel: getTypeHint(val) + packageName}
      if util.isFunction(val)
        # convert arguments to snippet placeholders
        prompts = getFunctionArguments(val).map (arg, i) -> "${#{i + 1}:#{arg}}"
        cmp.snippet = "#{key}(#{prompts.join(', ')})"
      cmp
  catch error
    console.error "unable to load completions for '#{packageName}':", error.message
    return null

isMatch = (cmp, prefix) -> (cmp.snippet ? cmp.text).indexOf(prefix) is 0

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
    for cmp in @completions[name] when isMatch(cmp, prefix)
      util._extend cmp, {replacementPrefix: prefix}

  # Required: Return a promise, an array of suggestions, or null.
  getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
    [varName, prefix] = @getPrefix(editor, bufferPosition)
    if @completions[varName]?
      return @getPackageCompletions(varName, prefix)
    else
      match = editor.getText().match "#{varName}\\s+=\\s+require[ \\(]['\"](\\w+)['\"]"
      if match?
        moduleName = match[1]
        @addCompletions(varName, generatePackageCompletions(moduleName))
        return @getPackageCompletions(varName, prefix)
      return []

###
TODO
* option to reset cache
* NODE_PATH variable for global modules
* settings page
###
