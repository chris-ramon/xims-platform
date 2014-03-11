describe('Sign In Page', function() {
  it('should sign in user', function() {
    var signInPage = require('./sign_in_page.js');
    signInPage.get();
    signInPage.setEmail('chris@gmail.com');
    signInPage.setPassword('246813579');
    signInPage.submitSignIn();
    expect(browser.getCurrentUrl()).toEqual('http://0.0.0.0:9000/#/');
    expect(signInPage.currentUser.getText()).toMatch(/\w+/i);
  });
});

describe('Sign Out Page', function() {
  it('should sign out user', function() {
    var signOutPage = require('./sign_out_page.js');
    signOutPage.get();
    signOutPage.signOut();
    expect(browser.getCurrentUrl()).toEqual('http://0.0.0.0:9000/#/');
    expect(signOutPage.currentUser.getText()).toMatch('');
  });
});