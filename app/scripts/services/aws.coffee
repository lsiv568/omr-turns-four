'use strict';

angular.module('videoCaptureApp')
  .factory 'Aws', ($http, $q) ->

    AWS_BASE = package.config.aws_base

    AWS_POST_URL = "#{AWS_BASE}/upload"

    AWS_GET_URL = "#{AWS_BASE}/gifs"

    # Public API here
    {
      addGif: (base64Gif) ->
        data =
          file: base64Gif
        $http.post(AWS_POST_URL, data)
        .success (response) ->
          console.log 'Successfully posted to AWS via Zoltan'
        .error (error) ->
          console.error "Error posting to AWS via zolton: #{error}"

      getGifs: ->
        d = $q.defer()
        $http.get(AWS_GET_URL)
        .success (response) ->
          d.resolve response
        .error (error) ->
          d.reject error
        d.promise
    }
