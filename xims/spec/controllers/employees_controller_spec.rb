require 'spec_helper'

describe EmployeesController do

  describe 'index' do
    it "won't allow see the list of employees when user is not logged in" do
      xhr :get, :index, organization_id: 1
      response.should_not be_success
    end
    context 'when logged in' do
      let(:abc_organization) { create(:organization) }
      let(:chris_as_employee) {create( :employee, organization: abc_organization) }
      let(:chris_as_user) { create(:user, employee: chris_as_employee) }
      let(:other_organization) { create(:organization) }
      let(:add_employees_to_other_organization) { 3.times { create(:employee, organization: other_organization) }  }
      before do
        3.times { create(:employee, organization: abc_organization) }
        sign_in chris_as_user
      end
      context 'when user do not belongs to the given organization' do
        it 'fails' do
          xhr :get, :index, organization_id: other_organization.id
          response.should_not be_success
        end
      end
      context 'when user belongs to the given organization' do
        it 'succeeds' do
          xhr :get, :index, organization_id: abc_organization.id
          response.should be_success
        end
        it 'returns employees only for the given organization' do
          add_employees_to_other_organization
          xhr :get, :index, organization_id: abc_organization.id
          response.should be_success
          parsed = JSON.parse(response.body)
          parsed['data'].length.should == 1
          parsed['meta']['current_page'].should == 1
        end
        it 'returns correct JSON format' do
          xhr :get, :index, organization_id: abc_organization.id
          response.should be_success
          parsed = JSON.parse(response.body)
          parsed['data'][0].should have_key('id')
          parsed['data'][0].should have_key('id_number')
          parsed['data'][0].should have_key('first_name')
          parsed['data'][0].should have_key('middle_name')
          parsed['data'][0].should have_key('last_name')
          parsed['data'][0].should have_key('second_last_name')
        end
        it 'paginates' do
          xhr :get, :index, organization_id: abc_organization.id, page: 3
          parsed = JSON(response.body)
          parsed['meta']['total_items'].should == 4
          parsed['meta']['current_page'].should == 3
        end
      end
    end
  end

  describe 'show' do
    it "won't allow see employee if not logged in" do
      xhr :get, :show, organization_id: 1, employee_id: 1
      response.should_not be_success
    end

    describe 'when logged in' do
      let(:abc_organization) { create(:organization) }
      let(:other_organization) { create(:organization) }
      let(:roger_as_employee) { create(:employee, organization: abc_organization) }
      let(:roger_as_user) { create(:user, employee: roger_as_employee) }
      let(:chris_as_employee) { create(:employee, organization: other_organization) }
      let(:luis_as_employee) { create(:employee, organization: abc_organization) }
      before do
        sign_in roger_as_user
      end
      describe 'user does not belong to the organization' do
        it 'fails' do
          xhr :get, :show, employee_id: chris_as_employee.id
          response.should_not be_success
        end
      end
      describe 'user belongs to the organization' do
        it 'succeed' do
          xhr :get, :show, employee_id: luis_as_employee.id
          response.should be_success
        end
      end
    end
  end
end
