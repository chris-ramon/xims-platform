FactoryGirl.define do
  factory :employee do
    organization { FactoryGirl.create(:organization) }
    individual { FactoryGirl.create(:individual) }
    workspace { FactoryGirl.create(:workspace) }
    occupation { FactoryGirl.create(:occupation) }

    factory :employee_with_entities do
      after(:create) do |employee, evaluator|
        create(:risk_insurance, employee: employee)
        create(:medical_exam, employee: employee)
        training = create(:training,
               organization: employee.organization)
        create(:training_employee,
               training: training,
               employee: employee)
      end
    end
  end
end