'use strict'

angular.module('videoCaptureApp')
  .controller 'DisplayCtrl', ($scope, $rootScope, gifs, Realtime) ->

    $scope.gifs = gifs

    Realtime.listenOnFor Realtime.GIFS_NAMESPACE, 'created', (data) ->
     $scope.$apply ->
       $scope.gifs.splice $scope.gifs.length - 1, 1 if $scope.gifs.length is $rootScope.MAX_NUM_GIFS
       $scope.gifs.unshift data.gif if data?.gif?
