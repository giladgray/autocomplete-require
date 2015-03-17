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
    end = cursor.getBufferPosition()
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
    waitsForPromise -> atom.workspace.open('test.coffee')
    runs -> editor = atom.workspace.getActiveTextEditor()

  it 'returns something', ->
    editor.setText('foo = fs.')
    expect(getCompletions().length).toBeGreaterThan 0

  it 'filters completion by prefix', ->
    editor.setText('foo = fs.readFi')
    expect(getCompletions().length).toBe 2
