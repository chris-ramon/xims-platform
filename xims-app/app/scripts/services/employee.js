'use strict';


angular.module('ximsApp')
  .service('EmployeeService', ['$http', function($http) {
    var self = this;
    self.getAll = function() {
      return $http({
        method: 'GET',
        url: 'http://0.0.0.0:3000/1/employees'
      });
    }
  }]);