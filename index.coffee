{EventEmitter}  = require 'events'
debug           = require('debug')('meshblu-connector-initial-state:index')
IS              = require 'initial-state'
_               = require 'lodash'
schemas         = require './legacySchemas.coffee'


class InitialState extends EventEmitter
  constructor: ->
    debug 'InitialState constructed'
    @options = {}
    @bucket = {}

  isOnline: (callback) =>
    callback null, running: true

  close: (callback) =>
    debug 'on close'
    callback()

  onMessage: (message) =>
    return unless message?
    { topic, devices, fromUuid } = message
    return if '*' in devices
    return if fromUuid == @uuid
    debug 'onMessage', { topic }
    payload = message.payload
    @bucket[payload.bucket].push payload.event, payload.value

  onConfig: (config) =>
    return unless config?
    debug 'on config', @uuid
    @setOptions config.options

  setOptions: (options={}) =>
    if !_.isEqual @options, options
      @options = options
      @createBucket()

  createBucket: () =>
    self = @
    if self.options.bucket?
      _.forEach self.options.bucket, (new_bucket) ->
        if !self.bucket[new_bucket]?
          self.bucket[new_bucket] = IS.bucket new_bucket, self.options.access_key if self.options.access_key?
     schemas.messageSchema.properties.bucket.enum = self.options.bucket
     self.emit 'update', {messageSchema: schemas.messageSchema}

  start: (device) =>
    { @uuid } = device
    debug 'started', @uuid
    @emit 'update', schemas

module.exports = InitialState
