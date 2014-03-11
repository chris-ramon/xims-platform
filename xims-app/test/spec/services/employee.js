'use strict';


describe('EmployeeService', function() {
  var EmployeeService, $httpBackend;
  beforeEach(function() {
    module('ui.bootstrap');
    module('ximsApp');
  });
  beforeEach(inject(function($injector) {
    EmployeeService = $injector.get('EmployeeService');
    $httpBackend = $injector.get('$httpBackend');
    $httpBackend.whenGET('http://0.0.0.0:3000/search/employees?page=2&term=some+term')
      .respond(Fixtures.searchEmployees);
  }));
  describe('.search', function() {
    it('should update the state of loadingEmployees', function() {
      EmployeeService.search("some term", 2);
      expect(EmployeeService.loadingEmployees).toEqual(true);
      $httpBackend.flush();
      expect(EmployeeService.loadingEmployees).toEqual(false);
    });
  });
});