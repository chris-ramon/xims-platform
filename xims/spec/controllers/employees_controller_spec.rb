require 'spec_helper'

describe EmployeesController do
  let(:abc_total_outsourced_employees) { 5 }
  let(:abc_organization_provider) { create(:organization_with_employees, employees_count: abc_total_outsourced_employees) }
  let(:abc_outsourcing) { create(:outsourcing, outsourcer: abc_organization,
                                 provider: abc_organization_provider) }
  let(:abc_organization) { create(:organization) }
  let(:other_organization) { create(:organization) }
  let(:roger_as_employee) { create(:employee, organization: abc_organization) }
  let(:roger_as_user) { create(:user, employee: roger_as_employee) }
  let(:chris_as_employee) { create(:employee, organization: other_organization) }
  let(:luis_as_employee) { create(:employee_with_entities, organization: abc_organization) }
  let(:jorge_as_employee) { create(:employee_with_entities, organization: abc_organization_provider) }

  describe 'index' do
    it "won't allow see the list of employees when user is not logged in" do
      xhr :get, :index, organization_id: 1
      response.should_not be_success
    end
    context 'when logged in' do
      let(:abc_total_employees) { 3 }
      let(:abc_organization) { create(:organization) }
      let(:abc_outsourcing) { create(:outsourcing, outsourcer: abc_organization,
                                     provider: abc_organization_provider) }
      let(:chris_as_employee) {create( :employee, organization: abc_organization) }
      let(:chris_as_user) { create(:user, employee: chris_as_employee) }
      let(:other_organization) { create(:organization) }
      let(:add_employees_to_other_organization) { 3.times { create(:employee, organization: other_organization) }  }
      before do
        abc_total_employees.times { create(:employee, organization: abc_organization) }
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
          abc_organization_provider
          abc_outsourcing
          xhr :get, :index, organization_id: abc_organization.id, page: 3
          parsed = JSON(response.body)
          total_items = abc_total_employees + 1 + abc_total_outsourced_employees #+1 counting the employee entity of the logged user
          parsed['meta']['total_items'].should == total_items
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
        context 'when requesting for provider employee' do
          it 'succeeds' do
            abc_organization_provider
            abc_outsourcing
            xhr :get, :show, employee_id: jorge_as_employee.id
            response.should be_success
          end
        end
      end
    end
  end

  describe 'update' do
    let(:expiration_date) { Time.now }
    before do
      sign_in roger_as_user
    end
    describe 'when logged in and not allowed' do
      it 'fails' do
        xhr :put, :update, employee_id: chris_as_employee.id,
            employee: {risk_insurance: {expiration_date: expiration_date},
                       medical_exam: {expiration_date: expiration_date}}
        response.should_not be_success
      end
    end
    describe 'when logged in and allowed' do
      it 'succeeds' do
        xhr :put, :update, employee_id: luis_as_employee.id,
            employee: {risk_insurance: {expiration_date: expiration_date},
                       medical_exam: {expiration_date: expiration_date}}
        response.should be_success
        parsed = JSON(response.body)
        parsed['employee']['risk_insurance']['expiration_date'].to_date.should == expiration_date.utc.to_date
        parsed['employee']['medical_exam']['expiration_date'].to_date.should == expiration_date.utc.to_date
      end
      it 'should succeeds when updating only one attribute' do
        xhr :put, :update, employee_id: luis_as_employee.id,
            employee: {medical_exam: {expiration_date: expiration_date}}
        response.should be_success
        parsed = JSON(response.body)
        parsed['employee']['medical_exam']['expiration_date'].to_date.should == expiration_date.utc.to_date
      end
      it 'fails and returns the errors' do
        xhr :put, :update, employee_id: luis_as_employee.id,
            employee: {risk_insurance: {expiration_date: nil},
                       medical_exam: {expiration_date: nil}}
        response.should_not be_success
        parsed = JSON(response.body)
        parsed.should have_key('errors')
      end
      it 'succeeds when employee does not have risk_insurance either medical_exam' do
        xhr :put, :update, employee_id: roger_as_employee.id,
            employee: {risk_insurance: {expiration_date: expiration_date},
                       medical_exam: {expiration_date: expiration_date}}
        response.should be_success
        parsed = JSON(response.body)
        parsed['employee']['risk_insurance']['expiration_date'].to_date.should == expiration_date.utc.to_date
        parsed['employee']['medical_exam']['expiration_date'].to_date.should == expiration_date.utc.to_date
      end
    end
  end
end
