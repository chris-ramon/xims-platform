'use strict';


angular.module('ximsApp').controller('EmployeeListFiltersCtrl',
  ['$scope', '$rootScope', 'EmployeeAlertsService', 'EmployeeService',
    'UserService',
    function($scope, $rootScope, EmployeeAlertsService, EmployeeService,
             UserService) {
      $scope.EmployeeAlertsService = EmployeeAlertsService;

      $scope.setEmployeesFiltered = function(filter, page) {
        EmployeeAlertsService.getAll(filter, page, true);
      };

      $scope.init = function() {
        $scope.updateFilters();
      };

      $scope.updateFilters = function() {
        var l = EmployeeAlertsService.filters.length;
        for(var i=0; i<l; i++) {
          EmployeeAlertsService.getAll(EmployeeAlertsService.filters[i]);
        }
      };

      // when user refresh the page
      $rootScope.$on('userLogged', function() { $scope.init(); });
      // when user visits the module
      if(UserService.currentUser) { $scope.init(); }
    }]);