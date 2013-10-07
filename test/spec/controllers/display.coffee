'use strict'

describe 'Controller: DisplayCtrl', () ->

  # load the controller's module
  beforeEach module 'videoCaptureApp'

  DisplayCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    DisplayCtrl = $controller 'DisplayCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3;
