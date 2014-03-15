describe('employees page', function() {
  var signInPage = require('../pages/sign_in_page.js'),
    signOutPage = require('../pages/sign_out_page.js'),
    employeesPage = require('../pages/employees_page.js');

  it('beforeAll', function() {
    signInPage.signIn();
    browser.waitForAngular();
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
  describe('when applying a filter', function() {
    it('should display the filter applied message', function() {
      employeesPage.get();
      employeesPage.riskInsuranceExpiredButton.click();
      expect(employeesPage.filterAppliedMessage.isDisplayed()).toBe(true);
    });
  });
  describe('when clearing the filter', function() {
    it('should hide the filter applied message', function() {
      employeesPage.get();
      employeesPage.riskInsuranceExpiredButton.click();
      employeesPage.filterAppliedMessage.click();
      expect(employeesPage.filterAppliedMessage.isDisplayed()).toBe(false);
    });
  });
  it('should list filters', function() {
    employeesPage.get();
    expect(employeesPage.riskInsuranceFilter.getText()).toMatch(/d+/);
    expect(employeesPage.medicalExamFilter.getText()).toMatch(/d+/);
    expect(employeesPage.noInductionFilter.getText()).toMatch(/d+/);
  });
  it('afterAll', function() {
    signOutPage.signOut();
  });
});


