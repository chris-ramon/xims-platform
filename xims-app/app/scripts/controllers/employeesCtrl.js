'use strict';


angular.module('ximsApp')
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