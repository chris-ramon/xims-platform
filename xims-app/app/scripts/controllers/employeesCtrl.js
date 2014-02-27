'use strict';

angular.module('ximsApp')
  .controller('EmployeeListCtrl', function(ModuleService, EmployeeService, $scope) {
    ModuleService.name = ModuleService.EMPLOYEE;
    $scope.employees = [];
    $scope.meta = {};
    EmployeeService.getAll()
      .success(function(response) {
        $scope.employees = response.data;
        $scope.meta['total_pages'] = response.meta.total_pages;
        $scope.meta['current_page'] = response.meta.current_page;
      });
    $scope.getTotalPages = function() { return new Array($scope.meta.total_pages); }
    $scope.isActivePage = function(index) { return (index + 1) == $scope.meta.current_page; }
  })
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