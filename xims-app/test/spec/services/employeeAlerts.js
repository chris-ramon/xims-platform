'use strict';


describe('EmployeeAlertsService', function() {
  var $httpBackend, EmployeeAlertsService;
  beforeEach(function() {
    module('ui.bootstrap');
    module('ximsApp');
  });
  beforeEach(inject(function($injector) {
    $httpBackend = $injector.get('$httpBackend');
    $httpBackend.whenGET('http://0.0.0.0:3000/1/employees/alerts/1/')
      .respond(Fixtures.alertEmployees);

    EmployeeAlertsService = $injector.get('EmployeeAlertsService');
    spyOn(EmployeeAlertsService, 'getAllUrl')
      .andReturn('http://0.0.0.0:3000/1/employees/alerts/1/');
  }));

  describe('.getAll', function() {
    it('should update the filter', function() {
      EmployeeAlertsService.getAll(EmployeeAlertsService.riskInsuranceExpired);
      $httpBackend.flush();
      expect(EmployeeAlertsService.riskInsuranceExpired['meta']).toBeDefined();
      expect(EmployeeAlertsService.riskInsuranceExpired['data']).toBeDefined();
    })
  });
});