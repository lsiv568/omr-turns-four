'use strict';

angular.module('videoCaptureApp')
  .factory 'Realtime', ->

    NODE_URL = package.config.node_url

    GIFS_NAMESPACE = '/gifs'

    baseSocket = io.connect NODE_URL

    sendWarmupMessage = ->
      warmupData =
        event: 'created'
        namespace: GIFS_NAMESPACE
        data:
          gif: null
      baseSocket.emit 'post', warmupData

    class Socket
      constructor: (namespace, event, callback) ->
        @socket = io.connect "#{NODE_URL}#{namespace}"
        # due to current bug with node server, need to send a 'warm-up' message to the namespace
        sendWarmupMessage()
        @socket.on 'connect', ->
          console.log "Connected to #{NODE_URL} on namespace #{namespace}"
        @socket.on event, (data) ->
          callback data

    listenOnFor = (namespace, event, callback) ->
      new Socket namespace, event, callback

    # Public API here
    {
      GIFS_NAMESPACE: GIFS_NAMESPACE

      gifCreated: (base64Gif) ->
        data =
          event: 'created'
          namespace: GIFS_NAMESPACE
          data:
            gif: base64Gif
        baseSocket.emit 'post', data

      listenOnFor: listenOnFor
    }
