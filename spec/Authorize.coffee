noflo = require 'noflo'
chai = require 'chai' unless chai
Authorize = require '../components/Authorize.coffee'

describe 'Authorize component', ->
  c = null
  account = null
  credentials = null
  beforeEach ->
    c = Authorize.getComponent()
    account = noflo.internalSocket.createSocket()
    credentials = noflo.internalSocket.createSocket()
    c.inPorts.account.attach account
    c.outPorts.credentials.attach credentials

  describe 'when instantiated', ->
    it 'should have an account port', ->
      chai.expect(c.inPorts.account).to.be.an 'object'
    it 'should have an credentials port', ->
      chai.expect(c.outPorts.credentials).to.be.an 'object'
