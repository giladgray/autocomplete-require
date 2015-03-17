provider = require './provider'

module.exports =
  activate: ->
    console.log 'activate require provider'
    provider.loadCompletions()

  getProvider: -> provider
