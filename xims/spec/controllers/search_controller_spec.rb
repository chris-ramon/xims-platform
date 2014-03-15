require 'spec_helper'

describe SearchController do
  describe 'employees' do
    context 'when user logged in and is allowed' do
      let(:abc_organization) { create(:organization) }
      let(:chris_as_individual) { create(:individual, first_name: 'chris') }
      let(:chris_as_employee) { create(:employee,
                                       organization: abc_organization,
                                       individual: chris_as_individual) }
      let(:chris_as_user) { create(:user, employee: chris_as_employee) }
      before do
        sign_in chris_as_user
        Individual.reindex
      end
      context 'when search by id number' do
        it 'it succeeds and responds correct JSON' do
          xhr :get, :employees,
              term: chris_as_individual.id
          response.should be_success
          parsed = JSON(response.body)
          parsed['data'].length.should == 1
        end
      end
      context 'when search by names' do
        it 'it succeeds and responds correct JSON' do
          xhr :get, :employees,
              term: chris_as_individual.first_name
          response.should be_success
          parsed = JSON(response.body)
          parsed['data'].length.should == 1
          parsed['data'][0].should have_key('id_number')
          parsed['data'][0].should have_key('first_name')
          parsed['data'][0].should have_key('middle_name')
          parsed['data'][0].should have_key('last_name')
          parsed['data'][0].should have_key('second_last_name')
        end
        it 'paginates' do
          create(:employee,
                 individual: create(:individual, first_name: 'chris'),
                 organization: abc_organization)
          Individual.reindex
          xhr :get, :employees,
              term: 'chris', page: 1
          response.should be_success
          parsed = JSON(response.body)
          parsed['data'].length.should == 1
          parsed['meta']['total_items'].should == 2
          parsed['meta']['current_page'].should == 1
        end
      end
    end
    context 'when user logged in and not shares organization id' do
      let(:abc_organization) { create(:organization) }
      let(:chris_as_employee) { create(:employee, organization: abc_organization) }
      let(:chris_as_user) { create(:user, employee: chris_as_employee) }
      let(:other_organization) { create(:organization) }
      let(:roger_as_individual) { create(:individual, first_name: 'roger') }
      let(:roger_as_employee) { create(:employee,
                                       individual: roger_as_individual,
                                       organization: other_organization) }
      before do
        chris_as_user
        roger_as_employee
        Individual.reindex
        sign_in chris_as_user
      end
      it 'returns nothing' do
        xhr :get, :employees, term: 'roger'
        response.should be_success
        parsed = JSON(response.body)
        parsed['data'].length.should == 0
      end
    end
  end
end