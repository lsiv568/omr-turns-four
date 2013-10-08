'use strict'

describe 'Service: realtime', () ->

  # load the service's module
  beforeEach module 'videoCaptureApp'

  # instantiate service
  realtime = {}
  beforeEach inject (_realtime_) ->
    realtime = _realtime_

  it 'should do something', () ->
    expect(!!realtime).toBe true;
