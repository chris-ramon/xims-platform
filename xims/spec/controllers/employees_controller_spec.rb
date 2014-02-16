require 'spec_helper'

describe EmployeesController do

  describe 'show' do
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
          parsed = JSON.parse(response.body)
          parsed['data'].length.should == 4
        end
        it 'returns employees only for the given organization' do
          other_organization = create(:organization)
          3.times { create(:employee, organization: other_organization) }

          xhr :get, :index, organization_id: @abc_organization.id
          response.should be_success
          parsed = JSON.parse(response.body)
          parsed['data'].length.should == 4
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
          page = 2
          xhr :get, :index, organization_id: @organization.id, page: page
          response.should be_success
          parsed = JSON(response.body)
          parsed['metadata']['page'].should == page.to_s
          parsed['data'].length.should == @extra_total_per_page + 1 # + 1 because we are creating one employee within before
        end
      end
    end
  end
end