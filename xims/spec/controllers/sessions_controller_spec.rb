require 'spec_helper'

describe SessionsController do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  describe 'create' do
    let(:chris_as_user) { create(:user_with_employee, email: 'r@gmail.com', password: 'my_password') }
    it 'returns correct JSON structure' do
      xhr :get, :create, user: {email: chris_as_user.email, password: chris_as_user.password}
      parsed = JSON(response.body)
      employee = parsed['employee']
      employee.should have_key('first_name')
      employee.should have_key('middle_name')
      employee.should have_key('last_name')
      employee.should have_key('second_last_name')
    end
  end
end
