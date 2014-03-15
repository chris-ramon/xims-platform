var employeesPage = function() {
  this.employeesList = element.all(by.repeater('employee in EmployeeService.employees'));
  this.searchButton = element(by.id('empSearchBtn'));
  this.riskInsuranceExpiredButton = element(by.id('riskInsuranceExpiredBtn'));
  this.filterAppliedMessage = element(by.id('empFilterMessage'));
  this.riskInsuranceFilter = element(by.binding('EmployeeAlertsService.riskInsuranceExpired.meta.total_items'));
  this.medicalExamFilter = element(by.binding('EmployeeAlertsService.medicalExamExpired.meta.total_items'));
  this.noInductionFilter = element(by.binding('EmployeeAlertsService.noInductionTraining.meta.total_items'));
  this.employeeModuleTab = element(by.id('empModuleAnchor'));
  this.get = function() {
    browser.get('http://0.0.0.0:9000/#/trabajadores/');
  }
};

module.exports = new employeesPage();