'use strict';


angular.module('ximsApp')
  .controller('EmployeeListFiltersCtrl',
    ['$scope', 'EmployeeAlertsService', 'AppSettings',
      function($scope, EmployeeAlertsService, AppSettings) {
        $scope.isAlertFilterActive = false;
        $scope.currentAlertFilter = null;
        $scope.employeeAlertsType = AppSettings.employeeAlertsType;
        $scope.employeesRiskInsuranceExpired = [];
        $scope.employeesmedicalExamExpired = [];
        $scope.employeesnoInductionTraining = [];

        $scope.setEmployeesFiltered = function(employeeAlertsType, page) {
          $scope.currentAlertFilter = employeeAlertsType;
          EmployeeAlertsService.getAll($scope.currentAlertFilter, page)
            .success(function(response) {
              $rootScope.emit('setEmployees', response);
            });
        };

      }]);