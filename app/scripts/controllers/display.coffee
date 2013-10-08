'use strict'

angular.module('videoCaptureApp')
  .controller 'DisplayCtrl', ($scope, Realtime) ->

    $scope.gifs = []

    Realtime.listenOnFor Realtime.GIFS_NAMESPACE, 'created', (data) ->
      console.log data

