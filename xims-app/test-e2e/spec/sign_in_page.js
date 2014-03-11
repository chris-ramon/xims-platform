var SignInPage = function() {
  this.emailInput = element(by.model('userForm.email'));
  this.passwordInput = element(by.model('userForm.password'));
  this.signInButton = element(by.id('signInBtn'));
  this.currentUser = element(by.binding('UserService.currentUser.first_name'));
  this.get = function() {
    browser.get('http://0.0.0.0:9000/#/sign_in');
  };
  this.setEmail = function(email) {
    this.emailInput.sendKeys(email);
  };
  this.setPassword = function(password) {
    this.passwordInput.sendKeys(password);
  };
  this.submitSignIn = function() {
    this.signInButton.click();
  };
  this.signIn = function() {
    this.get();
    this.setEmail('chris@gmail.com');
    this.setPassword('246813579');
    this.submitSignIn();
  }
};

module.exports = new SignInPage();