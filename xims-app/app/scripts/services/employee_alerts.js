'use strict';


angular.module('ximsApp')
  .service('EmployeeAlertsService', ['$http', 'UserService',
    function($http, UserService) {
      var self = this;
      self.getAll = function(alert_type, page) {
        return $http({
          method: 'GET',
          url: this.getAllUrl(alert_type),
          params: {page: page}
        });
      };
      self.getAllUrl = function(alert_type) {
        var url = 'http://0.0.0.0:3000/:organization_id/employees/alerts/:alert_type/';
        return url
          .replace(':organization_id', UserService.currentUser.organization.id)
          .replace(':alert_type', alert_type);
      };
      self.search = function(term, page) {
        var _page = page || 1;
        var url = 'http://0.0.0.0:3000/search/employees';
        return $http({
          url: url,
          method: 'GET',
          params: {term: term, page: _page}
        });
      };
    }]);