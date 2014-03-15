var SignOutPage = function() {
  this.currentUser = element(by.binding('UserService.currentUser.first_name'));
  this.signOutAnchor = element(by.id('signOutAnchor'));
  this.get = function() {
    browser.get('http://0.0.0.0:9000/#/');
  };
  this.signOut = function() {
    this.currentUser.click(); // open drop-down
    this.signOutAnchor.click();
  }
};

module.exports = new SignOutPage();