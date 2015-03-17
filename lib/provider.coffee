module.exports =
  # This will work on JavaScript and CoffeeScript files, but not in js comments.
  selector: '.source.js, .source.coffee'
  disableForSelector: '.source.js .comment'

  # This will take priority over the default provider, which has a priority of 0.
  inclusionPriority: 1

  loadCompletions: ->
    console.log 'providing!!'

  # Required: Return a promise, an array of suggestions, or null.
  getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
    # line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
    # console.log line

    return [
      text: 'something'
    ,
      text: 'cool note'
      rightLabel: 'foo'
    ]

  # (optional): called _after_ the suggestion `replacementPrefix` is replaced
  # by the suggestion `text` in the buffer
  # onDidInsertSuggestion: ({editor, triggerPosition, suggestion}) ->

  # (optional): called when your provider needs to be cleaned up. Unsubscribe
  # from things, kill any processes, etc.
  # dispose: ->
