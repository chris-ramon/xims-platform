'use strict';

angular.module('ximsApp')
  .controller('EmployeeListCtrl',
    ['$scope', '$filter', '$rootScope', 'ModuleService', 'UserService',
      'EmployeeService', 'EmployeeAlertsService', 'AppSettings',
      function($scope, $filter, $rootScope, ModuleService, UserService,
               EmployeeService, EmployeeAlertsService, AppSettings) {
        ModuleService.name = ModuleService.EMPLOYEE;
        $scope.EmployeeService = EmployeeService;

        $scope.maxSize = AppSettings.pagination.maxSize;
        $scope.itemsPerPage = AppSettings.pagination.itemsPerPage;

        $scope.searchText = "";

        $scope.setEmployees = function(page) {
          if($scope.searchText)
            EmployeeService.search($scope.searchText, page);
          else
            EmployeeService.getAll(page);
        }

        $scope.$watch("searchText", filterEmployees);
        function filterEmployees() {
          var result = $filter('filter')($scope.EmployeeService.employeesCache, $scope.searchText);
          if(result.length) { $scope.EmployeeService.employees = result; }
        }

        // when user refresh the page
        $rootScope.$on('userLogged', function() { $scope.setEmployees(); });
        // when user visits the module
        if(UserService.currentUser) { $scope.setEmployees(); }
      }]);