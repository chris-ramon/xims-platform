'use strict';

angular.module('ximsApp')
  .service('UserService', function($http) {
    var self = this;
    self.currentUser = null;
    self.signIn = function(userForm) {
      return $http({
        url: 'http://0.0.0.0:3000/users/sign_in',
        method: 'POST',
        data: {
          user: {
            email: userForm.email,
            password: userForm.password}}
      }).success(updateCurrentUser);
    }
    self.signOut = function() {
      return $http({
        url: 'http://0.0.0.0:3000/users/sign_out',
        method: 'DELETE'
      }).success(afterSignOut);
    }
    self.setCurrentUser = function() {
      return $http({
        url: 'http://0.0.0.0:3000/users/current_user',
        method: 'GET'
      }).success(updateCurrentUser);
    }
    function updateCurrentUser(r, status) {
      self.currentUser = {};
      self.currentUser.email = r.email;
    }
    function afterSignOut() {
      self.currentUser = null;
    }
  });

