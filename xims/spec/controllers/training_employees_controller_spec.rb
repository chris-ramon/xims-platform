require 'spec_helper'

describe TrainingEmployeesController do
  let(:abc_organization) { create(:organization) }
  let(:chris_as_employee) { create(:employee, organization: abc_organization) }
  let(:chris_as_user) { create(:user, employee: chris_as_employee) }
  describe 'index_employees' do
    context 'when logged in' do
      let(:abc_training) { create(:training_with_employees, employees_count: 2,
                                  organization: abc_organization)  }
      before do
        sign_in chris_as_user
      end
      context 'logged user and training have same organization' do
        it 'succeeds' do
          xhr :get, :index_employees, training_id: abc_training.id
          response.should be_success
        end
        it 'returns a list of employees' do
          xhr :get, :index_employees, training_id: abc_training.id
          parsed = JSON(response.body)
          parsed['data'].length.should == 1
          parsed['data'][0].should have_key('id_number')
          parsed['data'][0].should have_key('first_name')
          parsed['data'][0].should have_key('last_name')
          parsed['data'][0].should have_key('observations')
        end
        it 'paginates the list' do
          xhr :get, :index_employees, training_id: abc_training.id, page: 1
          parsed = JSON(response.body)
          parsed['metadata']['page'].should == 1
          parsed['metadata']['total_pages'].should == 2
        end
      end
      context 'logged user and training DO NOT have same organization' do
        it 'fails' do
          chris_as_employee.organization = create(:organization)
          chris_as_employee.save
          xhr :get, :index_employees, training_id: abc_training.id
          response.should_not be_success
        end
      end
    end
  end
  describe 'index_trainings' do
    context 'when logged in' do
      let(:roger_as_employee) { create(:employee, organization: abc_organization) }
      let(:abc_training_employee) { create_list(:training_employee, 5,
                                           employee: roger_as_employee) }
      before do
        sign_in chris_as_user
      end
      context 'logged user and employee have same organization' do
        it 'succeeds' do
          abc_training_employee
          xhr :get, :index_trainings, employee_id: roger_as_employee.id
          response.should be_success
          parsed = JSON(response.body)
          parsed['data'].length.should == 1
          parsed['data'][0].should have_key('topic')
          parsed['data'][0].should have_key('training_hours')
          parsed['data'][0].should have_key('training_date')
          parsed['data'][0].should have_key('training_type')
        end
        it 'paginates the results' do
          abc_training_employee
          xhr :get, :index_trainings,
              employee_id: roger_as_employee.id, page: 2
          response.should be_success
          parsed = JSON(response.body)
          parsed['metadata']['page'].should == 2
          parsed['metadata']['total_pages'].should == 5
        end
      end
      context 'logged user and employee DO NOT have same organization' do
        it 'fails' do
          chris_as_employee.organization = create(:organization)
          chris_as_employee.save
          xhr :get, :index_trainings, employee_id: roger_as_employee.id
          response.should_not be_success
        end
      end
    end
  end
end
