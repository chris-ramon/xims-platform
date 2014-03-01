describe('sign in page', function() {
  var ptor = protractor.getInstance();
  it('should login user', function() {
    ptor.get('http://0.0.0.0:9000/#/sign_in');
    element(by.model('userForm.email')).sendKeys('chris@gmail.com');
    element(by.model('userForm.password')).sendKeys('246813579');
    element(by.id('signInBtn')).click();
    expect(ptor.getCurrentUrl()).toEqual('http://0.0.0.0:9000/#/');
  });
});

describe('employees page', function() {
  var ptor = protractor.getInstance(),
    employeesList;
  it('should list employees', function() {
    ptor.get('http://0.0.0.0:9000/#/trabajadores');
    employeesList = element.all(by.repeater('employee in employees'));
    expect(employeesList.count()).toBeGreaterThan(0);
  });
  describe('when search', function() {
    it('should list employees when empty search text', function() {
      ptor.get('http://0.0.0.0:9000/#/trabajadores');
      element(by.id('empSearchBtn')).click();
      employeesList = element.all(by.repeater('employee in employees'));
      expect(employeesList.count()).toBeGreaterThan(0);
    });
  });
  describe('when going to employees module', function() {
    it('should list employees', function() {
      element(by.id('empModuleAnchor')).click();
      employeesList = element.all(by.repeater('employee in employees'));
      expect(employeesList.count()).toBeGreaterThan(0);
    });
  })
});

