'use strict';
var alert_employees = {
  data: [{id: 11, id_number: 45996137, first_name: 'luis'}],
  meta: {total_items: 1, current_page: 1}
};

describe('EmployeeListFiltersCtrl', function () {
  var $httpBackend, $controller, $rootScope, $scope, EmployeeAlertsService;

  beforeEach(function() {
    module('ui.bootstrap');
    module('ximsApp');
  });
  beforeEach(inject(function($injector) {
    $httpBackend = $injector.get('$httpBackend');
    $httpBackend.whenGET('http://0.0.0.0:3000/1/employees/alerts/1/')
      .respond(alert_employees);

    $controller = $injector.get('$controller');
    $rootScope = $injector.get('$rootScope');
    $scope = $rootScope.$new();
    $controller('EmployeeListCtrl', {$scope: $scope});

    EmployeeAlertsService = $injector.get('EmployeeAlertsService');
    spyOn(EmployeeAlertsService, 'getAllUrl')
      .andReturn('http://0.0.0.0:3000/1/employees/alerts/1/');
  }));

//  describe('setEmployeesFiltered', function() {
//    it('should set employees and employeeCache', function() {
//      $scope.setEmployeesFiltered(1, null);
//      $httpBackend.flush();
//      expect($scope.employees).toEqual(alert_employees.data);
//    });
//  });
});
