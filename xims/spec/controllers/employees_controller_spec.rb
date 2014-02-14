require 'spec_helper'

describe EmployeesController do
  describe 'show' do
    it 'succeeds' do
      3.times { create(:employee) }

      xhr :get, :index
      response.should be_success
      parsed = JSON.parse(response.body)
      parsed.length.should == 3
    end
    it 'returns employees only for the given organization' do
      abc_organization = create(:organization)
      other_organization = create(:organization)
      3.times { create(:employee, organization: abc_organization) }
      3.times { create(:employee, organization: other_organization) }

      xhr :get, :index, organization_id: abc_organization.id
      response.should be_success
      parsed = JSON.parse(response.body)
      parsed.length.should == 3
    end
  end
end