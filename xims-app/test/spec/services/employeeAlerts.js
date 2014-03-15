'use strict';


describe('EmployeeAlertsService', function() {
  var $httpBackend, EmployeeAlertsService;
  beforeEach(function() {
    module('ui.bootstrap');
    module('ximsApp');
  });
  beforeEach(inject(function($injector) {
    $httpBackend = $injector.get('$httpBackend');
  }));

  describe('.getAll', function() {
    beforeEach(inject(function($injector) {
      $httpBackend.whenGET('http://0.0.0.0:3000/1/employees/alerts/1/')
        .respond(Fixtures.alertEmployees);

      EmployeeAlertsService = $injector.get('EmployeeAlertsService');
      spyOn(EmployeeAlertsService, 'getAllUrl')
        .andReturn('http://0.0.0.0:3000/1/employees/alerts/1/');
    }));
    it('should update the filter', function() {
      EmployeeAlertsService.getAll(EmployeeAlertsService.riskInsuranceExpired);
      $httpBackend.flush();
      expect(EmployeeAlertsService.riskInsuranceExpired['meta']).toBeDefined();
      expect(EmployeeAlertsService.riskInsuranceExpired['data']).toBeDefined();
    })
  });

  describe('search', function() {
    var EmployeeService;
    beforeEach(inject(function($injector) {
      $httpBackend.whenGET('http://0.0.0.0:3000/search/employees?alert_type=1&page=1&term=45996137')
        .respond(Fixtures.alertEmployees);
      EmployeeAlertsService = $injector.get('EmployeeAlertsService');
      EmployeeAlertsService.currentFilter = EmployeeAlertsService.riskInsuranceExpired;
      EmployeeService = $injector.get('EmployeeService');
    }));
    it('should set response data to EmployeeService', function() {
      EmployeeAlertsService.search(45996137);
      $httpBackend.flush();
      expect(EmployeeService.employees).toEqual(Fixtures.alertEmployees.data);
    });
    it('should not modified current filter', function() {
      EmployeeAlertsService.search(45996137);
      $httpBackend.flush();
      expect(EmployeeAlertsService.currentFilter)
        .toEqual(EmployeeAlertsService.riskInsuranceExpired);
    });
  });
});