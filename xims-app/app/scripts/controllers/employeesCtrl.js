'use strict';

angular.module('ximsApp')
  .controller('EmployeeListCtrl',
    ['$scope', '$filter', 'ModuleService', 'EmployeeService', 'AppSettings',
      function($scope, $filter, ModuleService, EmployeeService, AppSettings) {
    ModuleService.name = ModuleService.EMPLOYEE;
    $scope.employees = [];
    $scope.employeesCache = [];
    $scope.meta = {};
    $scope.totalItems = 0;
    $scope.currentPage = 0;
    $scope.searchText = "";
    $scope.searchingEmployees = true;
    $scope.maxSize = AppSettings.pagination.maxSize;
    $scope.itemsPerPage = AppSettings.pagination.itemsPerPage;

    $scope.setEmployees = function(page) {
      EmployeeService.getAll(page)
        .success(function(response) {
          $scope.employees = response.data;
          $scope.employeesCache = response.data;
          $scope.totalItems = response.meta.total_items;
          $scope.currentPage = response.meta.current_page;
          $scope.searchingEmployees = false;
        });
    }
    
    $scope.search = function() {
      if($scope.searchingEmployees) { return; }
      $scope.searchingEmployees = true;
    }

    $scope.$watch("searchText", function(newVal) {
      setEmployeesFiltered(newVal);
    });

    function setEmployeesFiltered(newVal) {
      var result = $filter('filter')($scope.employeesCache, newVal);
      if(result.length) { $scope.employees = result; }
      else { $scope.employees = $scope.employeesCache; }
    }

    (function() {
      $scope.setEmployees();
    })();
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