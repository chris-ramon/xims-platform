require 'spec_helper'

describe SearchController do
  describe 'search' do
    context 'when user logged in and is allowed' do
      context 'when search by id number' do
        before(:each) do
          @individual = create(:individual)
          Individual.reindex
        end
        it 'it succeeds and responds correct JSON' do
          xhr :get, :employees,
              term: @individual.id_number
          response.should be_success
          parsed = JSON(response.body)
          parsed['data'].length.should == 1
        end
      end
      context 'when search by names' do
        before do
          create(:individual, first_name: 'chris roger')
          create(:individual, first_name: 'chris ramon')
          Individual.reindex
        end
        it 'it succeeds and responds correct JSON' do
          xhr :get, :employees,
              term: 'chris'
          response.should be_success
          parsed = JSON(response.body)
          parsed['data'].length.should == 2
          parsed['data'][0].should have_key('id_number')
          parsed['data'][0].should have_key('first_name')
          parsed['data'][0].should have_key('middle_name')
          parsed['data'][0].should have_key('last_name')
          parsed['data'][0].should have_key('second_last_name')
        end
      end
    end
  end
end