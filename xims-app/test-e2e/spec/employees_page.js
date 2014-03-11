var employeesPage = function() {
  this.employeesList = element.all(by.repeater('employee in EmployeeService.employees'));
  this.searchButton = element(by.id('empSearchBtn'));
  this.employeeModuleTab = element(by.id('empModuleAnchor'));
  this.get = function() {
    browser.get('http://0.0.0.0:9000/#/trabajadores/');
  }
};

module.exports = new employeesPage();