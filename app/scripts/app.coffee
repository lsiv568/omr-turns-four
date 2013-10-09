'use strict'

angular.module('videoCaptureApp', [])
  .config ($routeProvider, $locationProvider) ->

    gifResolve = (Aws) ->
      Aws.getGifs()

    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/display',
        templateUrl: 'views/display.html'
        controller: 'DisplayCtrl'
        resolve:
          gifs: gifResolve
      .otherwise
        redirectTo: '/'

    $locationProvider.html5Mode true
  .run ($rootScope) ->

    $rootScope.MAX_NUM_GIFS = 50
