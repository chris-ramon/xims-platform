'use strict';


describe('EmployeeListFiltersCtrl', function () {
  var $httpBackend, $controller, $rootScope, $scope, EmployeeAlertsService, EmployeeService;

  beforeEach(function() {
    module('ui.bootstrap');
    module('ximsApp');
  });
  beforeEach(inject(function($injector) {
    $httpBackend = $injector.get('$httpBackend');
    $httpBackend.whenGET('http://0.0.0.0:3000/1/employees/alerts/1/')
      .respond(Fixtures.alertEmployees);
    $httpBackend.whenGET('http://0.0.0.0:3000/1/employees/alerts/2/')
      .respond(Fixtures.alertEmployees);
    $httpBackend.whenGET('http://0.0.0.0:3000/1/employees/alerts/3/')
      .respond(Fixtures.alertEmployees);

    $controller = $injector.get('$controller');
    $rootScope = $injector.get('$rootScope');
    $scope = $rootScope.$new();
    $controller('EmployeeListFiltersCtrl', {$scope: $scope});
    EmployeeService = $injector.get('EmployeeService');
    EmployeeAlertsService = $injector.get('EmployeeAlertsService');
  }));

  describe('.setEmployeesFiltered', function() {
    beforeEach(function() {
      spyOn(EmployeeAlertsService, 'getAllUrl')
        .andReturn('http://0.0.0.0:3000/1/employees/alerts/1/');
    });
    it('should set employees and employeeCache', function() {
      $scope.setEmployeesFiltered(EmployeeAlertsService.riskInsuranceExpired, null);
      $httpBackend.flush();
      expect(EmployeeService.employees)
        .toEqual(Fixtures.alertEmployees.data);
      expect(EmployeeService.employeesCache)
        .toEqual(Fixtures.alertEmployees.data);
    });
  });
  describe('.updateFilters', function() {
    beforeEach(function() {
      spyOn(EmployeeAlertsService, 'getAllUrl')
        .andCallFake(function(alertType) {
          return 'http://0.0.0.0:3000/1/employees/alerts/:alert_type/'
            .replace(':alert_type', alertType);
        });
    });
    it('should update all the filters', function() {
      $scope.updateFilters();
      $httpBackend.flush();
      expect(EmployeeAlertsService.riskInsuranceExpired['meta']).toBeDefined();
      expect(EmployeeAlertsService.riskInsuranceExpired['data']).toBeDefined();
      expect(EmployeeAlertsService.medicalExamExpired['meta']).toBeDefined();
      expect(EmployeeAlertsService.medicalExamExpired['data']).toBeDefined();
      expect(EmployeeAlertsService.noInductionTraining['meta']).toBeDefined();
      expect(EmployeeAlertsService.noInductionTraining['data']).toBeDefined();
    });
    });
});
