'use strict';

angular.module('videoCaptureApp')
  .directive 'gifCreator', ($timeout) ->

    hasUserMedia = ->
      invalid = [null, undefined, '']
      navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia
      window.URL = window.URL || window.webkitURL || window.mozURL || window.msURL
      navigator.getUserMedia not in invalid  and window.URL not in invalid

    getDataURL = (blob, callback) ->
      reader = new FileReader()
      reader.readAsDataURL blob
      reader.onload = (event) ->
        callback event.target.result

    templateUrl: 'views/gif_creator.html'
    restrict: 'E'
    scope: {
      gifs: '='
      callback: '&'
    }

    link: (scope, element, attrs) ->

      video = null
      frameRate = attrs.frameRate || 200
      duration = attrs.duration * 1000 || 5000
      gifWidth = attrs.gifWidth || 200
      gifHeight = attrs.gifHeight || 200
      scope.recording = false
      scope.gifs = scope.gifs || []
      scope.stitching = false

      if hasUserMedia()
        navigator.getUserMedia {video: true}, (localMediaStream) ->
          video = document.getElementById 'record-me'
          video.src = window.URL.createObjectURL localMediaStream
          video.play()
        , (error) ->
          console.log error
      else
        alert 'You are using a terrible browser.  Unable to use Gif Creator'

      scope.startRecording = (event) ->
        if not scope.recording
          event.preventDefault()
          scope.recording = true
          scope.countdownTime = 3
          # countdown until recording starts
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
          canvas.width = gifWidth
          canvas.height = gifHeight
          ctx = canvas.getContext '2d'
          gif = new GIF {workers: 2, quality: 10, width: gifWidth, height: gifHeight, repeat: 0}

          aspectRatio = video.videoWidth/video.videoHeight
          wide = (aspectRatio) * canvas.height
          offset = canvas.width * (aspectRatio-1) / 2
          frames = []
          # at the specified frame rate take a snapshot of the current video stream by throwing into the canvas
          # take the canvas image and push it into the frames array
          imageCaptureIntervalID = setInterval ->
            ctx.drawImage video, -offset, 0, wide, canvas.height
            imageEle = document.createElement 'img'
            imageEle.src = canvas.toDataURL 'image/png'
            frames.push imageEle
          , frameRate

          # interval countdown for time remaining
          scope.$apply ->
            scope.timeRemaining = duration / 1000
          timeRemainingIntervalID = setInterval ->
            scope.$apply ->
              scope.timeRemaining -= 1
          , 1000

          # Create a timer for the specified duration.  Once it expires, kill the image capture interval
          # timer and stich together the images in the frames array via the GIF instance created above
          $timeout ->
            clearInterval imageCaptureIntervalID
            clearInterval timeRemainingIntervalID
            video.pause()
            angular.forEach frames, (frame) ->
              gif.addFrame frame, {delay: frameRate}
            gif.on 'finished', (blob) ->
              getDataURL blob, (url) ->
                console.log url
                scope.$apply ->
                  scope.gifs.unshift url
                  scope.gifs = scope.gifs
                  # provide the url to the callback
#                  scope.callback {url: url} if scope.callback
            gif.on 'progress', (progress) ->
              scope.$apply ->
                if progress is 1
                  scope.stitching = false
                  video.play() # keep the video rolling after stitching is complete
                else
                  scope.stitching = true
              # dislay a progress bar while video is being stitched together
            gif.render()
            window.URL.revokeObjectURL video.src # free up object url
            scope.recording = false
          , duration
