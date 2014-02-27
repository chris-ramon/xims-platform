'use strict';


angular.module('ximsApp')
  .service('EmployeeService', ['$http', 'UserService', function($http, UserService) {
    var self = this;
    self.getAll = function() {
      var url = 'http://0.0.0.0:3000/:organization_id/employees';
      url = url.replace(':organization_id', UserService.currentUser.organization.id);
      return $http({
        method: 'GET',
        url: url
      });
    }
  }]);