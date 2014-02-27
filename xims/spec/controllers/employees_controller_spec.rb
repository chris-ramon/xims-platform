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
          chris_as_employee.organization = other_organization
          chris_as_employee.save
          xhr :get, :index, organization_id: abc_organization.id
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
          parsed['meta']['total_pages'].should == 4
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
      end
    end
  end

  describe 'show' do
    it "won't allow see employee if not logged in" do
      xhr :get, :show, organization_id: 1, employee_id: 1
      response.should_not be_success
    end

    describe 'when logged in' do
      before do
        @organization = create(:organization)

        @chris_as_employee = create(:employee, organization: @organization)
        roger_as_employee = create(:employee, organization: @organization)

        roger_as_user = create(:user_with_employee, employee: roger_as_employee)
        sign_in roger_as_user
      end
      describe 'user does not belong to the organization' do
        it 'fails' do
          @chris_as_employee.organization = create(:organization)
          @chris_as_employee.save
          xhr :get, :show, employee_id: @chris_as_employee.id
          response.should_not be_success
        end
      end
      describe 'user belongs to the organization' do
        it 'succeed' do
          xhr :get, :show, employee_id: @chris_as_employee.id
          response.should be_success
        end
      end
    end
  end

  #describe 'alerts' do
  #  context 'when user logged in' do
  #    let(:abc_organization) { create(:organization) }
  #    let(:chris_as_employee) { create(:employee, organization: abc_organization) }
  #    let(:chris_as_user) { create(:user, employee: chris_as_employee) }
  #    before do
  #      sign_in chris_as_user
  #    end
  #    context 'user belongs to the organization' do
  #      it 'succeeds' do
  #        xhr :get, :alerts, organization_id: abc_organization
  #        response.should be_success
  #      end
  #      it 'returns the correct data' do
  #        xhr :get, :alerts, organization_id: abc_organization
  #        parsed = JSON(response.body)
  #        parsed['expired_risk_insurance']['total'].should == 1
  #        parsed['expired_risk_insurance']['data'].should == 1
  #        parsed['expired_medical_exam']['total'].should == 1
  #        parsed['without_induction']['total'].should == 3
  #      end
  #    end
  #    context 'user does not belong to the organization' do
  #      other_organization = create(:organization)
  #      chris_as_employee.organization = other_organization
  #      chris_as_employee.save
  #      xhr :get, :alerts, organization_id: other_organization.id
  #      response.should_not be_success
  #    end
  #  end
  #end
end