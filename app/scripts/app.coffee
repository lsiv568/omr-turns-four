'use strict'

angular.module('videoCaptureApp', [])
  .config ($routeProvider, $locationProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/display',
        templateUrl: 'views/display.html'
        controller: 'DisplayCtrl'
      .otherwise
        redirectTo: '/'

    $locationProvider.html5Mode true
  .run ($rootScope) ->

    $rootScope.MAX_NUM_GIFS = 50
