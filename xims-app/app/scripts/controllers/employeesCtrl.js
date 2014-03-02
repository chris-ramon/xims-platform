'use strict';

angular.module('ximsApp')
  .controller('EmployeeListCtrl',
    ['$scope', '$filter', '$rootScope', 'ModuleService', 'UserService','EmployeeService', 'AppSettings',
      function($scope, $filter, $rootScope, ModuleService, UserService, EmployeeService, AppSettings) {
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
      if($scope.searchText == "")
        EmployeeService.getAll(page).success(successResponse);
      else
        EmployeeService.search($scope.searchText, page).success(successResponse);
    }
    
    $scope.search = function() {
      if($scope.searchingEmployees) { return; }
      if($scope.searchText == "") { $scope.setEmployees(); return; }
      $scope.searchingEmployees = true;
      EmployeeService.search($scope.searchText).success(successResponse);
    }

    $scope.$watch("searchText", function(newVal) {
      setEmployeesFiltered(newVal);
    });

    $scope.hidePagination = function() {
      if($scope.employees.length > 0) { return false; }
      else if ($scope.searchingEmployees) { return true; }
      else { return true; }
    }

    function setEmployeesFiltered(newVal) {
      var result = $filter('filter')($scope.employeesCache, newVal);
      if(result.length) { $scope.employees = result; }
      else { $scope.employees = $scope.employeesCache; }
    }

    function successResponse(response) {
      $scope.employees = response.data;
      $scope.employeesCache = response.data;
      $scope.totalItems = response.meta.total_items;
      $scope.currentPage = response.meta.current_page;
      $scope.searchingEmployees = false;
    }

    $rootScope.$on('userLogged', function() { $scope.setEmployees(); });
    if(UserService.currentUser) { $scope.setEmployees(); }
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