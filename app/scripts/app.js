// Generated by CoffeeScript 1.6.3
(function() {
  'use strict';
  angular.module('videoCaptureApp', []).config(function($routeProvider, $locationProvider) {
    $routeProvider.when('/', {
      templateUrl: 'views/main.html',
      controller: 'MainCtrl'
    }).when('/display', {
      templateUrl: 'views/display.html',
      controller: 'DisplayCtrl'
    }).otherwise({
      redirectTo: '/'
    });
    return $locationProvider.html5Mode(true);
  });

}).call(this);
