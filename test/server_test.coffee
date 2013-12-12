assert = require 'assert'
http = require 'http'
mockApiServer = require '../lib/index.js'
{readFile, unlink} = require 'fs'
{extend, findWhere, map, pick} = require 'underscore'

doRequest = (options, testFn) ->
  apiServerOptions = pick options, 'port', 'logToFile'

  mockApiServer apiServerOptions, (err, server) ->
    requestOptions =
      port: options.port
      hostname: 'localhost'
      method: 'GET'
      path: '/v2/hello'

    request = http.request requestOptions, (res) ->
      assert.equal 200, res.statusCode
      pageContents = ""
      res.on 'data', (chunk) ->
        pageContents += chunk
      res.on 'end', ->
        server.stop()
        testFn pageContents
    request.end()

describe 'a mock API server', ->

  it 'serves static API responses', (done) ->
    options =
      port: 7001

    doRequest options, (pageContents) ->
      assert.equal JSON.parse(pageContents).answer, "Hello, World!"
      done()

  it 'logs to a file when configured', (done) ->
    unlink './tmp/foo.log', ->
      options =
        port: 7002
        logToFile: "./tmp/foo.log"

      doRequest options, ->
        readFile './tmp/foo.log', (err, buffer) ->
          throw err if err?

          logLines = map buffer.toString().split(/\n/), (s) ->
            if s == ""
              null
            else
              JSON.parse s

          requestLogLine = findWhere logLines, message: '[MOCK-REQUEST]'
          assert.equal '/v2/hello', requestLogLine.meta.path
          done()
