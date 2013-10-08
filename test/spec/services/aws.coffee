'use strict'

describe 'Service: aws', () ->

  # load the service's module
  beforeEach module 'videoCaptureApp'

  # instantiate service
  aws = {}
  beforeEach inject (_aws_) ->
    aws = _aws_

  it 'should do something', () ->
    expect(!!aws).toBe true;
