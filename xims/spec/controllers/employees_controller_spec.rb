require 'spec_helper'

describe EmployeesController do

  describe 'index' do
    it "won't allow see the list of employees when user is not logged in" do
      xhr :get, :index, organization_id: 1
      response.should_not be_success
    end
    describe 'when logged in' do
      describe 'when user do not belongs to the given organization' do
        before do
          sign_in :user, create(:user)
        end
        it 'fails' do
          xhr :get, :index, organization_id: 1
          response.should_not be_success
        end
      end
      describe 'when user belongs to the given organization' do
        before do
          @abc_organization = create(:organization)
          @chris = create(:employee, organization: @abc_organization)
          3.times { create(:employee, organization: @abc_organization) }

          @user = create(:user, employee: @chris)
          sign_in :user, @user
        end
        it 'succeeds' do
          xhr :get, :index, organization_id: @abc_organization.id
          response.should be_success
        end
        it 'returns employees only for the given organization' do
          other_organization = create(:organization)
          3.times { create(:employee, organization: other_organization) }
          xhr :get, :index, organization_id: @abc_organization.id
          response.should be_success
          parsed = JSON.parse(response.body)
          parsed['data'].length.should == 1
          parsed['metadata']['total_pages'].should == 4
        end
      end
      describe 'pagination' do
        before do
          @organization = create(:organization)
          employee = create(:employee, organization: @organization)
          user = create(:user, employee: employee)

          @extra_total_per_page = 1
          total_per_page = Kaminari.config.default_per_page
          total_employees = total_per_page + @extra_total_per_page
          total_employees.times { create(:employee, organization: @organization) }

          sign_in user
        end
        it 'returns the given page' do
          xhr :get, :index, organization_id: @organization.id, page: 2
          response.should be_success
          parsed = JSON(response.body)
          parsed['metadata']['page'].should == 2
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
end