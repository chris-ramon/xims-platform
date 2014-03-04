FactoryGirl.define do
  factory :risk_insurance do
    employee { FactoryGirl.create(:employee) }
    expiration_date { Date.today + 10.days }
    active true
  end
end