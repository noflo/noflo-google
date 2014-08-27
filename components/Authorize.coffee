noflo = require 'noflo'
googleapis = require 'googleapis'

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Authorize with Google APIs'
  c.inPorts.add 'account',
    datatype: 'string'
    description: 'Google service account'
    required: true
  c.inPorts.add 'keyfile',
    datatype: 'string'
    description: 'Path to the private key file'
    required: true
  c.inPorts.add 'scopes',
    datatype: 'array'
    description: 'Authorization scopes'
    required: true
  c.outPorts.add 'credentials',
    datatype: 'object'
  c.outPorts.add 'error',
    datatype: 'object'

  noflo.helpers.WirePattern c,
    in: ['account', 'keyfile']
    params: 'scopes'
    out: 'credentials'
    forwardGroups: true
    async: true
  , (data, groups, out, callback) ->
    credentials = new googleapis.auth.Compute
    credentials.authorize (computeErr) ->
      # We already had credentials
      unless err
        out.send credentials
        do callback

      # Credentials fallback via JWT
      credentials = new googleapis.auth.JWT data.account, data.keyfile, c.params.scopes
      credentials.authorize (jwtErr) ->
        return callback jwtErr if jwtErr
        out.send credentials
        do callback

  c
