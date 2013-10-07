'use strict'

angular.module('videoCaptureApp')
  .controller 'MainCtrl', ($scope, $http) ->

    AWS_POST_URL = 'http://zoltan.omrcloud.com:3026/upload'
    NODE_URL = 'http://node.staging.robinpowered.com'

    postToAWS = (base64Gif) ->
      data =
        file: base64Gif
      $http.post AWS_POST_URL, data,
      (response) ->
        console.log 'Successfully posted to AWS via Zoltan'
      , (error) ->
        console.error "Error posting to AWS via zolton: #{error}"

    postToNode = (base64Gif) ->
      data =
        event: 'created'
        data:
          gif: base64Gif

      $http.post "#{NODE_URL}/gif-created", data,
      (response) ->
        console.log response
      , (error) ->
        console.log error

    $scope.animatedGifs = []

    $scope.startPosting = (base64Gif) ->
      postToAWS base64Gif
      postToNode base64Gif


