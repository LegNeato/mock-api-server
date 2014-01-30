{ResponseSpecification} = require './responder'

class Dsl
  constructor: (@_addResponseSpecification, [@_path]) ->

  with: (what) ->
    spec =
      path: @_path
      method: 'GET'
      query: {}
      content: what
    @_addResponseSpecification spec

module.exports = Dsl
