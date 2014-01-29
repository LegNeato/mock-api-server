patternMatcher = require './pattern_matcher'
{each, extend, filter, size, sortBy} = require 'underscore'
url = require 'url'

class ResponseSpecification
  constructor: ({@method, @path, @query, @content}) ->
    @path = @_stripExtension @path

  matches: (request) ->
    request.method == @method && @_matchesQuery(request.query)

  _matchesQuery: (query) ->
    matches = true
    each @query, (value, name) =>
      if !patternMatcher(value) query[name]
        matches = false
    matches

  _stripExtension: (path) ->
    path.replace /\.json$/, ''

class Responder
  constructor: (fsHash) ->
    @responseMap = @_buildResponseMap fsHash

  respondTo: (request) ->
    entries = @responseMap[@_stripExtension request.path]
    return undefined if entries == undefined

    allowedEntries = filter entries, (entry) ->
      entry.matches request
    return undefined if allowedEntries.length == 0

    allowedEntries[0].content

  withResponseSpecification: (newSpec) ->
    modifiedResponder = new Responder({})
    modifiedResponder.responseMap = extend {}, @responseMap

    list = (modifiedResponder.responseMap[newSpec.path] ? []).splice 0
    list.push newSpec
    modifiedResponder.responseMap[newSpec.path] = list

    modifiedResponder

  _stripExtension: (path) ->
    path.replace /\.json$/, ''

  _extractMethod: (filename) ->
    method = filename.split('/')[1]
    path = filename.replace /\/[^\/]*/, ''
    {method,path}

  _buildResponseMap: (fsHash) ->
    responseMap = {}
    each fsHash, (content, filename) =>
      entry = @_buildStaticResponseEntry filename, content
      responseMap[entry.path] ?= []
      responseMap[entry.path].push entry

    each responseMap, (entries, path) ->
      responseMap[path] = sortBy entries, (entry) ->
        1e9 - size entry.query

    responseMap

  _buildStaticResponseEntry: (filename, content) ->
    {pathname, query} = url.parse filename, true
    {method, path} = @_extractMethod @_stripExtension pathname
    new ResponseSpecification {content,method,path,query}

module.exports = {Responder, ResponseSpecification}
