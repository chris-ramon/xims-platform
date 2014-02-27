'use strict';

angular.module('ximsApp')
  .controller('EmployeeListCtrl',
    ['$scope', 'ModuleService', 'EmployeeService', 'AppSettings',
      function($scope, ModuleService, EmployeeService, AppSettings) {
    ModuleService.name = ModuleService.EMPLOYEE;
    $scope.employees = [];
    $scope.meta = {};
    $scope.totalItems = 0;
    $scope.currentPage = 0;
    $scope.maxSize = AppSettings.pagination.maxSize;
    $scope.itemsPerPage = AppSettings.pagination.itemsPerPage;
    $scope.setEmployees = function(page) {
      EmployeeService.getAll(page)
        .success(function(response) {
          $scope.employees = response.data;
          $scope.totalItems = response.meta.total_items;
          $scope.currentPage = response.meta.current_page;
        });
    }
    $scope.setEmployees();
  }])
  .controller('EmployeeCtrl', function(ModuleService, $routeParams, $scope) {
    ModuleService.name = ModuleService.EMPLOYEE;
    // $scope.employee = $routeParams.employeeId;
    $scope.employee = {id:1,
      displayName: 'Juan Perez', dni: 45996136,
      workingArea: 'Chancado', age: 35,
      riskInsurance: {expirationDate: '12/12/14'},
      medicalExamination: {expirationDate: '10/06/14'},
      occupation: 'Perforista'
    };
  })
  .controller('EmployeeUpdateCtrl', function(ModuleService, $routeParams, $scope) {
    ModuleService.name = ModuleService.EMPLOYEE;
    // $scope.employee = $routeParams.employeeId;
    $scope.employee = {id:1,
      displayName: 'Juan Perez', dni: 45996136,
      workingArea: 'Chancado', age: 35,
      riskInsurance: {expirationDate: '12/12/14'},
      medicalExamination: {expirationDate: '10/06/14'}};
  });