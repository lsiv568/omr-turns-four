'use strict'

angular.module('videoCaptureApp')
  .controller 'MainCtrl', ($scope, $http) ->

    postToAWS = (base64Gif) ->
      console.log base64Gif

    postToNode = (base64Gif) ->
      console.log base64Gif

    $scope.animatedGifs = []

    $scope.startPosting = (base64Gif) ->
      postToAWS base64Gif
      postToNode base64Gif


