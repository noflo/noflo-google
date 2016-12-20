noflo = require 'noflo'
chai = require 'chai' unless chai
GetClient = require '../components/GetClient.coffee'

describe 'GetClient component', ->
  c = null
  api = null
  version = null
  client = null
  beforeEach ->
    c = GetClient.getComponent()
    api = noflo.internalSocket.createSocket()
    version = noflo.internalSocket.createSocket()
    client = noflo.internalSocket.createSocket()
    c.inPorts.api.attach api
    c.inPorts.version.attach version
    c.outPorts.client.attach client

  describe 'when instantiated', ->
    it 'should have an version port', ->
      chai.expect(c.inPorts.version).to.be.an 'object'
    it 'should have an client port', ->
      chai.expect(c.outPorts.client).to.be.an 'object'

  describe 'getting the URL shortener client', ->
    it 'should produce a functional shortener client', (done) ->
      client.on 'data', (data) ->
        data.url.get
          shortUrl: 'http://goo.gl/xKbRu3'
        , (err, response) ->
          if err and err.message.indexOf('Daily Limit') isnt -1
            console.log "API limit exceeded, skipping"
            return done()
          return done err if err
          chai.expect(response).to.be.an 'object'
          chai.expect(response.status).to.equal 'OK'
          chai.expect(response.longUrl).to.equal 'https://www.google.com/'
          done()
      api.send 'urlshortener'
      version.send 'v1'
