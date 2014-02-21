grabAllLines = (fileContent) ->
  fileContent.toString('utf-8').split("\n")

parseStatusCode = (line) ->
  line.match(/\d{3}/)[0]

module.exports = (fileHash) ->
  responseHash = {}

  for path, contents of fileHash
    lines = grabAllLines(contents)

    firstLine = lines.shift()
    secondLine = lines.shift()

    status = parseStatusCode(firstLine)
    body = JSON.parse lines.join("\n")

    responseHash[path] = { status, body }

  responseHash