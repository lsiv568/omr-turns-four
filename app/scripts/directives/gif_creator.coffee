'use strict';

angular.module('videoCaptureApp')
  .directive 'gifCreator', ($timeout, $http) ->

    SPACE_BAR_KEY_CODE = 32

    hasUserMedia = ->
      !!(navigator.getUserMedia || navigator.webkitGetUserMedia ||
      navigator.mozGetUserMedia || navigator.msGetUserMedia)

    getDataURL = (blob, callback) ->
      reader = new FileReader()
      reader.readAsDataURL blob
      reader.onload = (event) ->
        callback event.target.result

    templateUrl: 'views/gif_creator.html'
    restrict: 'E'
    scope: {
      gifs: '='
    }

    link: (scope, element, attrs) ->

      video = null
      frameRate = attrs.frameRate || 200
      duration = attrs.duration || 5000
      recording = false
      scope.gifs = scope.gifs || []

      if hasUserMedia()
        navigator.webkitGetUserMedia {video: true}, (localMediaStream) ->
          video = document.getElementById 'record-me'
          video.src = window.URL.createObjectURL localMediaStream
        , (error) -> console.log error
      else
        alert 'You are using a terrible browser'

      window.addEventListener 'keyup', (event) ->
        if event.keyCode is SPACE_BAR_KEY_CODE and not recording
          event.preventDefault()
          recording = true
          scope.$apply ->
            scope.countdownTime = 3
          intervalID = setInterval ->
            if scope.countdownTime is 1
              clearInterval intervalID
              record()
            else
              scope.$apply ->
                scope.countdownTime -= 1
          , 1000

      record = ->
        if video
          scope.$apply ->
            scope.countdownTime = null
          canvas = document.getElementById 'output-canvas'
          canvas.width = 200
          canvas.height = 200
          ctx = canvas.getContext '2d'
          gif = new GIF {workers: 2, quality: 10, width: 200, height: 200, repeat: 0}

          video.play()

          frames = []
          intervalID = setInterval ->
            ctx.drawImage video, 0, 0, canvas.width, canvas.height
            imageEle = document.createElement 'img'
            imageEle.src = canvas.toDataURL 'image/png'
            frames.push imageEle
          , frameRate

          $timeout ->
            clearInterval intervalID
            video.pause()
            angular.forEach frames, (frame) ->
              gif.addFrame frame, {delay: frameRate}
            gif.on 'finished', (blob) ->
              getDataURL blob, (url) ->
                console.log url
                scope.$apply ->
                  scope.gifs.unshift url
                  scope.gifs = scope.gifs
                # here we would post the url to a server for storage
            gif.on 'progress', (progress) ->
              console.log progress
              # dislay a progress bar while video is being stitched together
            gif.render()
            window.URL.revokeObjectURL video.src # free up object url
            recording = false
          , duration
