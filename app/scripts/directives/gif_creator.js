// Generated by CoffeeScript 1.6.3
(function() {
  'use strict';
  angular.module('videoCaptureApp').directive('gifCreator', function($timeout, $http) {
    return {
      templateUrl: 'views/gif_creator.html',
      restrict: 'E',
      link: function(scope, element, attrs) {
        var SPACE_BAR_KEY_CODE, duration, frameRate, getDataURL, hasUserMedia, record, recording, video;
        SPACE_BAR_KEY_CODE = 32;
        hasUserMedia = function() {
          return !!(navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia);
        };
        getDataURL = function(blob, callback) {
          var reader;
          reader = new FileReader();
          reader.readAsDataURL(blob);
          return reader.onload = function(event) {
            return callback(event.target.result);
          };
        };
        video = null;
        frameRate = attrs.frameRate || 200;
        duration = attrs.duration || 5000;
        recording = false;
        scope.gifs = [];
        if (hasUserMedia()) {
          navigator.webkitGetUserMedia({
            video: true
          }, function(localMediaStream) {
            video = document.getElementById('record-me');
            return video.src = window.URL.createObjectURL(localMediaStream);
          }, function(error) {
            return console.log(error);
          });
        } else {
          alert('You are using a terrible browser');
        }
        window.addEventListener('keyup', function(event) {
          var intervalID;
          if (event.keyCode === SPACE_BAR_KEY_CODE && !recording) {
            event.preventDefault();
            recording = true;
            scope.$apply(function() {
              return scope.countdownTime = 3;
            });
            return intervalID = setInterval(function() {
              if (scope.countdownTime === 1) {
                clearInterval(intervalID);
                return record();
              } else {
                return scope.$apply(function() {
                  return scope.countdownTime -= 1;
                });
              }
            }, 1000);
          }
        });
        return record = function() {
          var canvas, ctx, frames, gif, intervalID;
          if (video) {
            scope.$apply(function() {
              return scope.countdownTime = null;
            });
            canvas = document.getElementById('output-canvas');
            canvas.width = 200;
            canvas.height = 200;
            ctx = canvas.getContext('2d');
            gif = new GIF({
              workers: 2,
              quality: 10,
              width: 200,
              height: 200,
              repeat: 0
            });
            video.play();
            frames = [];
            intervalID = setInterval(function() {
              var imageEle;
              ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
              imageEle = document.createElement('img');
              imageEle.src = canvas.toDataURL('image/png');
              return frames.push(imageEle);
            }, frameRate);
            return $timeout(function() {
              clearInterval(intervalID);
              video.pause();
              angular.forEach(frames, function(frame) {
                return gif.addFrame(frame, {
                  delay: frameRate
                });
              });
              gif.on('finished', function(blob) {
                return getDataURL(blob, function(url) {
                  console.log(url);
                  return scope.$apply(function() {
                    scope.gifs.unshift(url);
                    return scope.gifs = scope.gifs;
                  });
                });
              });
              gif.on('progress', function(progress) {
                return console.log(progress);
              });
              gif.render();
              window.URL.revokeObjectURL(video.src);
              return recording = false;
            }, duration);
          }
        };
      }
    };
  });

}).call(this);
