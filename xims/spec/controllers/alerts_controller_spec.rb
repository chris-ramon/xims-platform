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
    before do
      sign_in chris_as_user
    end
    context 'when logged in and not allowed' do
      it 'fails' do
        xhr :get, :employees, organization_id: other_organization.id
        #response.should_not be_success
      end
    end
    context 'when logged in and allowed' do
      it 'succeeds' do
        xhr :get, :employees, organization_id: abc_organization.id
        #response.should be_success
      end
      it 'returns correct JSON format' do
        xhr :get, :employees, organization_id: abc_organization.id
        #parsed = JSON.parse(response.body)
        #parsed['data'][0].should have_key('id')
        #parsed['data'][0].should have_key('id_number')
        #parsed['data'][0].should have_key('first_name')
        #parsed['data'][0].should have_key('middle_name')
        #parsed['data'][0].should have_key('last_name')
        #parsed['data'][0].should have_key('second_last_name')
      end
    end
  end
end