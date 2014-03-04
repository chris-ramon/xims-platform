FactoryGirl.define do
  factory :medical_exam do
    employee { FactoryGirl.create(:employee) }
    expiration_date { Date.today + 10.days }
    active true
  end
end