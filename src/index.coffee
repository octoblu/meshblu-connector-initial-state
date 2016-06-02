{EventEmitter}  = require 'events'
IS              = require 'initial-state'
_               = require 'lodash'
debug           = require('debug')('meshblu-connector-initial-state:index')

class InitialState extends EventEmitter
  constructor: ->
    debug 'InitialState constructed'
    @buckets = {}

  onMessage: (message={}) =>
    { bucket, event, value } = message.payload ? {}
    @bucket[bucket].push event, value

  onConfig: (device={}) =>
    debug 'on config'
    { buckets } = device.options ? {}
    _.each buckets, @maybeCreateBucket

  maybeCreateBucket: (bucket={}) =>
    { name, access_key } = bucket
    return unless name? || access_key?
    return if @buckets[name]?
    @buckets[name] = IS.bucket name, access_key

  start: (device) =>
    { @uuid } = device
    debug 'started', @uuid
    @onConfig device

module.exports = InitialState
