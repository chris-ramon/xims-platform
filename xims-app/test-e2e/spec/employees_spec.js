describe('employees page', function() {
  var signInPage = require('./sign_in_page.js'),
    signOutPage = require('./sign_out_page.js'),
    employeesPage = require('./employees_page.js');

  it('beforeAll', function() {
    signInPage.signIn();
  });

  it('should list employees', function() {
    employeesPage.get();
    expect(employeesPage.employeesList.count()).toBeGreaterThan(0);
  });
  describe('when search', function() {
    it('should list employees when empty search text', function() {
      employeesPage.get();
      employeesPage.searchButton.click();
      expect(employeesPage.employeesList.count()).toBeGreaterThan(0);
    });
  });
  describe('when going to employees module', function() {
    it('should list employees', function() {
      employeesPage.get();
      employeesPage.employeeModuleTab.click();
      expect(employeesPage.employeesList.count()).toBeGreaterThan(0);
    });
  });
//  describe('when quick filter', function() {
//    describe('when choose any filter', function() {
//      it('should list employees', function() {
//        element(by.id('riskInsuranceExpiredBox')).click();
//        employeesList = element.all(by.repeater('employee in employees'));
//        expect(employeesList.count()).toEqual(0);
//      });
//    });
//  });
  it('afterAll', function() {
    signOutPage.signOut();
  });
});


