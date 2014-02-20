FactoryGirl.define do
  factory :training do
    organization { FactoryGirl.create(:organization) }
    responsible { FactoryGirl.create(:individual) }
    trainer { FactoryGirl.create(:individual) }
    training_type Training::TRAINING_TYPE[:induction]
    sequence(:training_date) { |n| Time.now + n.weeks }
    training_hours { rand(1..50) }
    sequence(:topic) { |n| "#{n} topic" }

    factory :training_with_employees do
      ignore do
        employees_count 5
      end

      after(:create) do |training, evaluator|
        evaluator.employees_count.times {
          employee = FactoryGirl.create(:employee, organization: training.organization)
          create(:training_employee, training: training, employee: employee)
        }
      end
    end
  end

  factory :training_employee do
    training { FactoryGirl.create(:training) }
    employee { FactoryGirl.create(:employee) }
  end
end