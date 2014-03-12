'use strict';


angular.module('ximsApp')
  .service('EmployeeAlertsService', ['$http', 'UserService',
    function($http, UserService) {
      var self = this;
      self.riskInsuranceExpired = {id: 1};
      self.medicalExamExpired = {id: 2};
      self.noInductionTraining = {id: 3};
      self.filters = [
        self.riskInsuranceExpired, self.medicalExamExpired,
        self.noInductionTraining
      ];
      self.filterApplied = false;
      self.getAll = function(filter, page) {
        return $http({
          method: 'GET',
          url: this.getAllUrl(filter.id),
          params: {page: page}
        }).success(function(response) {
            afterGetAll(response, filter);
        });
      };
      self.getAllUrl = function(alertType) {
        var url = 'http://0.0.0.0:3000/:organization_id/employees/alerts/:alert_type/';
        return url
          .replace(':organization_id', UserService.currentUser.organization.id)
          .replace(':alert_type', alertType);
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

      function afterGetAll(response, filter) {
        self.filterApplied = true;
        angular.extend(filter, response);
      }
    }]);