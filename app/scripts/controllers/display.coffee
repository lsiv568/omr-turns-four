'use strict'

angular.module('videoCaptureApp')
  .controller 'DisplayCtrl', ($scope, Realtime) ->

    $scope.gifs = []

    Realtime.listenOnFor Realtime.GIFS_NAMESPACE, 'created', (data) ->
     $scope.$apply ->
      $scope.gifs.unshift data.gif if data?.gif?
      $scope.gifs = $scope.gifs

