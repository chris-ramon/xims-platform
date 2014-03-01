'use strict';

angular.module('ximsApp')
  .controller('MainCtrl', function ($scope, ModuleService) {
    ModuleService.name = ModuleService.HOME;
  })
  .controller('SidebarCtrl', function($scope, ModuleService) {
    $scope.currentModule = function(module) {
      return ModuleService.name === module;
    };
  })
  .controller('TopNavbarCtrl',
    ['$scope', '$route', '$rootScope', 'UserService',
      function($scope, $route, $rootScope, UserService) {
    UserService.setCurrentUser().success(function() {
      $rootScope.$emit('userLogged');
    });
    $scope.UserService = UserService;
    $scope.signOut = function() {
      UserService.signOut().success(function() { $route.reload(); });
    }
  }])
  .controller('TrainingCtrl', function(ModuleService, TrainingService, $scope) {
    ModuleService.name = ModuleService.TRAINING;
    $scope.training = {
      id: 1, registryNumber: 434, topic: 'Primeros Auxilios',
      responsible: {displayName: 'Juan Perez'},
      trainingType: 'Capacitación',
      trainingDate: '12/12/2013',
      trainingHours: 5, trainer: {displayName: 'Roberto Rodriguez Acurio'},
      trained: [
        {id: 1, dni: 45996135, displayName: 'Chris Ramón', firstName: 'Chris', middleName: 'Ramón'},
        {id: 2, dni: 45996556, displayName: 'Roger Rodriguez', firstName: 'Roger', middleName: 'Rodriguez'},
        {id: 3, dni: 45336556, displayName: 'Luis Rodriguez', firstName: 'Luis', middleName: 'Rodriguez'},
        {id: 4, dni: 45966556, displayName: 'John Doe', firstName: 'John', middleName: 'Doe', supplementaryRiskInsurance: {expired: true}},
        {id: 5, dni: 45998556, displayName: 'Michael Lara', firstName: 'Michael', middleName: 'Lara', supplementaryRiskInsurance: {expired: true}},
        {id: 6, dni: 45996956, displayName: 'Juan Perez', firstName: 'Juan', middleName: 'Perez', medicalExam: {expired: true}}
      ]};
  })
  .controller('TrainingListCtrl', function(ModuleService, TrainingService, $scope) {
    ModuleService.name = ModuleService.TRAINING;
    $scope.trainings = TrainingService.getAll();
  })
  .controller('TrainingNewCtrl', function(ModuleService, CompanyService, $scope) {
    ModuleService.name = ModuleService.TRAINING;
    $scope.company = CompanyService.getCompany();
    $scope.training = {};
    $scope.trained = undefined;
  });
