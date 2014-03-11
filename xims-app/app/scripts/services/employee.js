'use strict';


angular.module('ximsApp')
  .service('EmployeeService', ['$http', 'UserService',
    function($http, UserService) {
    var self = this;
    self.employees = [];
    self.employeesCache = [];
    self.totalItems = 0;
    self.currentPage = 0;
    self.loadingEmployees = false;

    self.getAll = function(page) {
      if(self.loadingEmployees) { return false; }
      self.loadingEmployees = true;
      return $http({
        method: 'GET',
        url: self.getAllUrl(),
        params: {page: page}
      }).success(employeesSuccess);
    };

    self.getAllUrl = function() {
      var url = 'http://0.0.0.0:3000/:organization_id/employees';
      return url.replace(':organization_id',
        UserService.currentUser.organization.id);
    };

    self.search = function(term, page) {
      if(self.loadingEmployees) { return false; }
      self.loadingEmployees = true;
      var _page = page || 1;
      var url = 'http://0.0.0.0:3000/search/employees';
      return $http({
        url: url,
        method: 'GET',
        params: {term: term, page: _page}
      }).success(employeesSuccess);
    };

    function employeesSuccess(response) {
      self.employees = response.data;
      self.employeesCache = response.data;
      self.totalItems = response.meta.total_items;
      self.currentPage = response.meta.current_page;
      self.loadingEmployees = false;
    }
  }]);