FactoryGirl.define do
  factory :incident_type do
    sequence(:name) { |n| "incident #{n}" }
  end
end