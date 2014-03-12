require 'spec_helper'


describe AlertsController do
  describe 'employees' do
    let(:abc_organization) { create(:organization) }
    let(:chris_as_employee) { create(:employee,
                                     organization: abc_organization) }
    let(:chris_as_user) { create(:user, employee: chris_as_employee) }
    let(:other_organization) { create(:organization) }
    let(:roger_as_individual) { create(:individual, first_name: 'roger') }
    let(:roger_as_employee) { create(:employee,
                                   individual: roger_as_individual,
                                   organization: other_organization) }
    let(:employees_result) { {employees: [Employee.new], total_items: 10} }
    let(:employees_result_empty) { {employees: [], total_items: 0} }
    let!(:user) { sign_in chris_as_user }
    context 'when logged in and not allowed' do
      before do
        Guardian.any_instance.stubs(:can_see_employee?)
          .returns(false)
        Alerts::Employee
          .any_instance.stubs(:risk_insurance_expired)
          .returns(employees_result)
      end
      it 'fails' do
        xhr :get, :employees,
            organization_id: other_organization.id,
            alert_type: Alerts::Employee.types[:risk_insurance_expired]
        response.should_not be_success
      end
    end
    context 'when logged in and allowed' do
      context 'when there are results' do
        before do
          Guardian.any_instance.stubs(:can_see_employee?).returns(true)
          Alerts::Employee.any_instance.stubs(:risk_insurance_expired)
            .returns(employees_result)
        end
        it 'succeeds' do
          xhr :get, :employees,
              organization_id: abc_organization.id,
              alert_type: Alerts::Employee.types[:risk_insurance_expired]
          response.should be_success
          parsed = JSON(response.body)
          parsed['data'].length.should == 1
          parsed['meta']['current_page'].should == nil
          parsed['meta']['total_items'].should == 10
        end
      end
      context 'when no results' do
        before do
          Guardian.any_instance.stubs(:can_see_employee?)
          .returns(true)
          Alerts::Employee
          .any_instance.stubs(:risk_insurance_expired)
          .returns(employees_result_empty)
        end
        it 'succeeds' do
          xhr :get, :employees,
              organization_id: abc_organization.id,
              alert_type: Alerts::Employee.types[:risk_insurance_expired]
          response.should be_success
          parsed = JSON(response.body)
          parsed['data'].length.should == 0
          parsed['meta']['current_page'].should == nil
          parsed['meta']['total_items'].should == 0
        end
      end
    end
  end
end