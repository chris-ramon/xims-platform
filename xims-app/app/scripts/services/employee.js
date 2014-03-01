'use strict';


angular.module('ximsApp')
  .service('EmployeeService', ['$http', 'UserService',
    function($http, UserService) {
    var self = this;
    self.getAll = function(page) {
      var url = 'http://0.0.0.0:3000/:organization_id/employees';
      url = url.replace(':organization_id',
        UserService.currentUser.organization.id);
      return $http({
        method: 'GET',
        url: url,
        params: {page: page}
      });
    }
    self.search = function(term, page) {
      var _page = page || 1;
      var url = 'http://0.0.0.0:3000/search/employees';
      return $http({
        url: url,
        method: 'GET',
        params: {term: term, page: _page}
      });
    }
  }]);