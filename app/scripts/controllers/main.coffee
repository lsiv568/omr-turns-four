'use strict'

angular.module('videoCaptureApp')
  .controller 'MainCtrl', ($scope, Aws, Realtime) ->

    $scope.animatedGifs = []

    $scope.gifCreated = (base64Gif) ->
      Aws.addGif base64Gif
      Realtime.gifCreated base64Gif


