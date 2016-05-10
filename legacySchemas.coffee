MESSAGE_SCHEMA =
  type: 'object'
  properties:
    bucket:
      type: 'string'
      required: true
    event:
      type: 'string'
      required: true
    value:
      type: 'string'
      required: true

OPTIONS_SCHEMA =
  type: 'object'
  properties:
    access_key:
      type: 'string'
      required: true
    bucket:
      type: 'array'
      items:
        type: "string"

module.exports = {
  messageSchema: MESSAGE_SCHEMA
  optionsSchema: OPTIONS_SCHEMA
}
