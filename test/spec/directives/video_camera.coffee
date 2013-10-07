'use strict'

describe 'Directive: videoCamera', () ->
  beforeEach module 'videoCaptureApp'

  element = {}

  it 'should make hidden element visible', inject ($rootScope, $compile) ->
    element = angular.element '<video-camera></video-camera>'
    element = $compile(element) $rootScope
    expect(element.text()).toBe 'this is the videoCamera directive'
