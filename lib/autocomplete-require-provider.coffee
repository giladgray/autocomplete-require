AutocompleteRequireProviderView = require './autocomplete-require-provider-view'
{CompositeDisposable} = require 'atom'

module.exports = AutocompleteRequireProvider =
  autocompleteRequireProviderView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @autocompleteRequireProviderView = new AutocompleteRequireProviderView(state.autocompleteRequireProviderViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @autocompleteRequireProviderView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'autocomplete-require-provider:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @autocompleteRequireProviderView.destroy()

  serialize: ->
    autocompleteRequireProviderViewState: @autocompleteRequireProviderView.serialize()

  toggle: ->
    console.log 'AutocompleteRequireProvider was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
