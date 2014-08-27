noflo = require 'noflo'
googleapis = require 'googleapis'

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Prepare a Google API client with credentials'
  c.inPorts.add 'credentials',
    datatype: 'object'
  c.inPorts.add 'api',
    datatype: 'string'
  c.inPorts.add 'version',
    datatype: 'string'
  c.outPorts.add 'client',
    datatype: 'object'
  c.outPorts.add 'error',
    datatype: 'object'

  noflo.helpers.WirePattern c,
    in: ['credentials', 'api', 'version']
    out: 'client'
    forwardGroups: true
    async: true
  , (data, groups, out, callback) ->
    unless googleapis[data.api]
      return callback new Error "Google API '#{data.api}' not available"
    client = googleapis[data.api]
      version: data.version
      auth: data.credentials
    out.send client
    do callback

  c
