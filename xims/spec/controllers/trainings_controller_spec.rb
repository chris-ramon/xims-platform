require 'spec_helper'

describe TrainingsController do
  describe 'index' do
    describe 'when logged in' do
      before do
        @total_trainings = 2
        @organization = create(:organization)
        @total_trainings.times { create(:training, organization: @organization) }
        chris_as_employee = create(:employee, organization: @organization)
        chris_as_user = create(:user, employee: chris_as_employee)
        sign_in chris_as_user
      end

      describe 'when user belongs same organization' do
        it 'succeed' do
          xhr :get, :index, organization_id: @organization.id
          response.should be_success
        end
      end

      describe 'pagination' do
        it 'succeeds' do
          xhr :get, :index, organization_id: @organization.id, page: 1
          parsed = JSON(response.body)
          parsed['data'].length.should == @total_trainings
          parsed['metadata']['page'].should == 1
          parsed['metadata']['total_pages'].should == 1
        end
      end
    end
  end

  describe 'show' do
    describe 'when logged in' do
      before do
        abc_organization = create(:organization)
        @chris_as_employee = create(:employee, organization: abc_organization)
        chris_as_user = create(:user, employee: @chris_as_employee)
        @induction_training = create(:training, organization: abc_organization)
        sign_in chris_as_user
      end
      describe 'logged user and training have same organization' do
        it 'succeeds' do
          xhr :get, :show, training_id: @induction_training.id
          response.should be_success
        end
      end

      describe 'logged user and training DO NOT have same organization' do
        it 'fails' do
          @chris_as_employee.organization = create(:organization)
          @chris_as_employee.save
          xhr :get, :show, training_id: @induction_training.id
          response.should_not be_success
        end
      end
    end
  end

  describe 'create' do
    context 'when logged in' do
      let(:abc_organization) { create(:organization) }
      let(:other_organization) { create(:organization) }
      let(:chris_as_employee) { create(:employee, organization: abc_organization) }
      let(:roger_as_employee) { create(:employee, organization: abc_organization) }
      let(:chris_as_user) { create(:user, employee: chris_as_employee) }
      let(:training_params) {
        {training: {organization_id: abc_organization.id, responsible_id: 1,
                    trainer_id: 1, training_type: Training::TRAINING_TYPE[:induction],
                    training_date: Time.now, training_hours: 2,
                    topic: 'some topic!',
                    employees: [{id: chris_as_employee.id,
                                 observations: 'some observation'},
                                {id: roger_as_employee.id}]},
         organization_id: abc_organization.id,
        }
      }
      before do
        sign_in chris_as_user
      end
      context 'logged user and training have same organization' do
        it 'succeeds' do
          xhr :post, :create, training_params
          response.should be_success
        end
      end
      context 'logged user and training DO NOT have same organization' do
        it 'fails' do
          chris_as_employee.organization = other_organization
          chris_as_employee.save
          xhr :post, :create, training_params
          response.should_not be_success
        end
      end

    end
  end
end