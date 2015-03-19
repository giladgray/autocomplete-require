provider = require '../lib/provider'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe 'AutocompleteRequireProvider', ->
  [editor, provider] = []

  getCompletions = ->
    cursor = editor.getLastCursor()
    start = cursor.getBeginningOfCurrentWordBufferPosition()
    end = editor.getEofBufferPosition()
    prefix = editor.getTextInRange([start, end])
    request =
      editor: editor
      bufferPosition: end
      scopeDescriptor: cursor.getScopeDescriptor()
      prefix: prefix
    return provider.getSuggestions(request)

  beforeEach ->
    waitsForPromise -> atom.packages.activatePackage('autocomplete-require')

    runs ->
      provider = atom.packages.getActivePackage('autocomplete-require').mainModule.getProvider()

    waitsFor -> Object.keys(provider.completions).length > 0

  describe 'CoffeeScript', ->
    beforeEach ->
      waitsForPromise -> atom.workspace.open('test.coffee')
      runs -> editor = atom.workspace.getActiveTextEditor()

    it 'returns no completions for empty string', ->
      editor.setText('')
      expect(getCompletions().length).toEqual 0

    it 'returns something', ->
      editor.setText('foo = fs.')
      expect(getCompletions().length).toBeGreaterThan 0

    it 'filters completion by prefix', ->
      editor.setText('foo = fs.readFi')
      expect(getCompletions().length).toBe 2

    it 'loads completions for other built-in libraries', ->
      editor.setText('readline = require "readline"\nreadline.')
      expect(getCompletions().length).toBeGreaterThan 0

    it 'stores completions under defined variable name', ->
      editor.setText('qs = require "querystring"\nqs.')
      expect(getCompletions().length).toBeGreaterThan 0

    it 'provides right label with module name', ->
      editor.setText('qs = require "querystring"\nqs.esc')
      expect(getCompletions()[0].rightLabel).toEqual 'querystring'

    it 'provides snippet with arguments for functions', ->
      editor.setText('qs = require "querystring"\nqs.esc')
      completion = getCompletions()[0]
      expect(completion.snippet).toEqual 'escape(${1:str})'

  describe 'JavaScript', ->
    beforeEach ->
      waitsForPromise -> atom.workspace.open('test.js')
      runs -> editor = atom.workspace.getActiveTextEditor()

    it 'loads completions for other built-in libraries', ->
      editor.setText('var readline = require("readline")\nreadline.')
      expect(getCompletions().length).toBeGreaterThan 0

    it 'stores completions under defined variable name', ->
      editor.setText('var qs = require("querystring")\nqs.')
      expect(getCompletions().length).toBeGreaterThan 0
