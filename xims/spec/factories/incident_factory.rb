FactoryGirl.define do
  factory :incident do
    incident_type { FactoryGirl.create(:incident_type) }
    sequence(:occurrence_date) { |n| Time.now + n.weeks }
  end
end