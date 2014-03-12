'use strict';


angular.module('ximsApp').controller('EmployeeListFiltersCtrl',
  ['$scope', '$rootScope', 'EmployeeAlertsService', 'EmployeeService', 'UserService', 'AppSettings',
    function($scope, $rootScope, EmployeeAlertsService, EmployeeService, UserService, AppSettings) {
      $scope.EmployeeAlertsService = EmployeeAlertsService;

      $scope.setEmployeesFiltered = function(filter, page) {
        EmployeeService.loadingEmployees = true;
        EmployeeAlertsService.getAll(filter, page)
          .success(EmployeeService.employeesSuccess);
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