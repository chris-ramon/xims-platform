'use strict';

angular.module('ximsApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute',
  'ui.bootstrap'
])
  .config(function ($routeProvider) {
    $routeProvider
      .when('/', {
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
      })
      .when('/sign_in', {
        templateUrl: 'views/session/sign_in.html',
        controller: 'SignInCtrl'
      })
      .when('/trabajadores', {
        templateUrl: 'views/employee/list.html',
        controller: 'EmployeeListCtrl'
      })
      .when('/trabajadores/:employeeId', {
        templateUrl: 'views/employee/detail.html',
        controller: 'EmployeeCtrl'
      })
      .when('/trabajadores/:employeeId/editar', {
        templateUrl: 'views/employee/edit.html',
        controller: 'EmployeeUpdateCtrl'
      })
      .when('/capacitaciones', {
        templateUrl: 'views/training/list.html',
        controller: 'TrainingListCtrl'
      })
      .when('/capacitaciones/nuevo', {
        templateUrl: 'views/training/new.html',
        controller: 'TrainingNewCtrl'
      })
      .when('/capacitaciones/:trainingId', {
        templateUrl: 'views/training/detail.html',
        controller: 'TrainingCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });
  });



