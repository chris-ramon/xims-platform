'use strict';


describe('EmployeeListCtrl', function () {
  var $httpBackend, $controller, $rootScope, $scope,
    EmployeeService;

  beforeEach(function() {
    module('ui.bootstrap');
    module('ximsApp');
  });
  beforeEach(inject(function($injector) {
    $httpBackend = $injector.get('$httpBackend');
    $httpBackend.whenGET('http://0.0.0.0:3000/1/employees')
      .respond(Fixtures.employeesIndex);
    $httpBackend.whenGET('http://0.0.0.0:3000/search/employees?page=1&term=45996130')
      .respond(Fixtures.searchEmployees);
    $httpBackend.whenGET('http://0.0.0.0:3000/search/employees?alert_type=1&page=1&term=45996137')
      .respond(Fixtures.alertEmployees);
    $httpBackend.whenGET('http://0.0.0.0:3000/1/employees/alerts/1/')
      .respond(Fixtures.employeesIndexFilter);

    $controller = $injector.get('$controller');
    $rootScope = $injector.get('$rootScope');
    $scope = $rootScope.$new();
    $controller('EmployeeListCtrl', {$scope: $scope});

    EmployeeService = $injector.get('EmployeeService');
    spyOn(EmployeeService, 'getAllUrl')
      .andReturn('http://0.0.0.0:3000/1/employees');
  }));

  describe('.setEmployees', function() {
    it('should set employees and employeesCache', function() {
      $scope.setEmployees(null);
      $httpBackend.flush();
      expect($scope.EmployeeService.employees)
        .toEqual(Fixtures.employeesIndex.data);
      expect($scope.EmployeeService.employeesCache)
        .toEqual(Fixtures.employeesIndex.data);
    });
    describe('when filterApplied', function() {
      var EmployeeAlertsService;
      beforeEach(inject(function($injector) {
        EmployeeAlertsService = $injector.get('EmployeeAlertsService');
        EmployeeAlertsService.filterApplied = true;
        EmployeeAlertsService.currentFilter = EmployeeAlertsService.riskInsuranceExpired;
        spyOn(EmployeeAlertsService, 'getAllUrl')
          .andReturn('http://0.0.0.0:3000/1/employees/alerts/1/');
      }));
      it('should set employees', function() {
        $scope.setEmployees(null);
        $httpBackend.flush();
        expect(EmployeeService.employees, Fixtures.employeesIndexFilter.data);
      });
    });
    describe('when filterApplied and searchText', function() {
      var EmployeeAlertsService;
      beforeEach(inject(function($injector) {
        EmployeeAlertsService = $injector.get('EmployeeAlertsService');
        EmployeeAlertsService.filterApplied = true;
        EmployeeAlertsService.currentFilter = EmployeeAlertsService.riskInsuranceExpired;
      }));
      it('should set employees', function() {
        $scope.$apply(function() { $scope.searchText = '45996137'; });
        $scope.setEmployees(null);
        $httpBackend.flush();
        expect(EmployeeService.employees, Fixtures.alertEmployees.data);
      });
    });
  });
  describe('.watch("searchText")', function() {
    beforeEach(inject(function() {
      EmployeeService.employees = Fixtures.employeesIndexFilter.data;
      EmployeeService.employeesCache = Fixtures.employeesIndexFilter.data;
    }));
    it('should filter by numbers', function() {
      $scope.$apply(function() { $scope.searchText = "1234"; });
      expect($scope.EmployeeService.employees.length).toEqual(2);
    });
    it('should filter by string', function() {
      $scope.$apply(function() { $scope.searchText = "chris"; });
      expect($scope.EmployeeService.employees.length).toEqual(1);
    });
    it('should filter by empty string', function() {
      $scope.$apply(function() { $scope.searchText = "1234"; });
      $scope.$apply(function() { $scope.searchText = ""; });
      expect($scope.EmployeeService.employees.length).toEqual(2);
    });
  });
});
