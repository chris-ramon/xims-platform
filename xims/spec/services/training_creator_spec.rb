require 'spec_helper'


describe TrainingCreator do
  describe 'create' do
    let(:user) { create(:user) }
    let(:organization) { create(:organization) }
    let(:employee_chris) { create(:employee) }
    let(:employee_roger) { create(:employee) }
    let(:training_params) {
      {training: {organization_id: organization.id, responsible_id: 1,
                  trainer_id: 1, training_type: Training::TRAINING_TYPE[:induction],
                  training_date: Time.now, training_hours: 2,
                  topic: 'some topic!',
                  employees: [{id: employee_chris.id,
                               observations: 'some observation'},
                              {id: employee_roger.id}]},
       }
    }
    let(:training_creator) { TrainingCreator.new(user, training_params[:training]) }

    it 'saves training' do
      training_creator.create
      training = Training.all.first
      training.present?.should == true
      training.organization.should == organization
    end

    it 'saves training employees' do
      training_creator.create
      training = Training.all.first
      training.training_employees.count.should == 2
    end
  end
end