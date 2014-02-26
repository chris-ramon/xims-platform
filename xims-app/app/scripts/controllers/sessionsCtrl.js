'use strict';

angular.module('ximsApp')
  .controller('SignInCtrl', ['$scope', 'UserService', '$location', function($scope, UserService, $location) {
    $scope.userForm = {};
    $scope.signIn = function() {
      UserService.signIn($scope.userForm)
        .success(function() {
          $location.path('/');
        })
        .error(function() {
          $scope.flashMessage = 'Email or Password incorrect!.'
        });
    }
  }]);