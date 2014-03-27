'use strict';


angular.module('ximsApp')
  .controller('EmployeeCtrl', ['ModuleService', '$routeParams', '$scope', 'EmployeeService',
    function(ModuleService, $routeParams, $scope, EmployeeService) {
      ModuleService.name = ModuleService.EMPLOYEE;
      EmployeeService.getOne($routeParams.employeeId)
        .success(function(r) { $scope.employee = r.employee; });
  }])
  .controller('EmployeeUpdateCtrl', ['ModuleService', '$routeParams', '$scope', 'EmployeeService',
    function(ModuleService, $routeParams, $scope, EmployeeService) {
    ModuleService.name = ModuleService.EMPLOYEE;
    EmployeeService.getOne($routeParams.employeeId)
      .success(function(r) { $scope.employee = r.employee; });

    // datepicker
    $scope.format = 'dd-MMMM-yyyy';
    $scope.minDate = new Date();
    $scope.open = function($event, model) {
      $event.preventDefault();
      $event.stopPropagation();
      model.opened = !model.opened;
    };

    $scope.save = function() {
      if($scope.employee)
        EmployeeService.updateOne($routeParams.employeeId, $scope.employee)
          .success(function(r) {
            // show message update successfully
            console.log(r);
          })
          .error(function() {
            // show message update failed
            console.log(r);
          });
    };
  }]);