'use strict'

angular.module('videoCaptureApp')
  .controller 'MainCtrl', ($scope, $rootScope, Aws, Realtime) ->

    $scope.animatedGifs = []

    $scope.gifCreated = (base64Gif) ->
      Aws.addGif base64Gif
      Realtime.gifCreated base64Gif
      # ensure gifs array does not exceed max
      $scope.animatedGifs.splice $scope.animatedGifs.length - 1, 1 if $scope.animatedGifs.length is $rootScope.MAX_NUM_GIFS


