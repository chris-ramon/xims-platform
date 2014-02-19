FactoryGirl.define do
  factory :training do
    organization { FactoryGirl.create(:organization) }
    responsible { FactoryGirl.create(:individual) }
    trainer { FactoryGirl.create(:individual) }
    training_type Training::TRAINING_TYPE[:induction]
    sequence(:training_date) { |n| Time.now + n.weeks }
    training_hours { rand(1..50) }
    sequence(:topic) { |n| "#{n} topic" }
  end
end