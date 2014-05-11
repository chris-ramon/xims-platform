FactoryGirl.define do
  factory :outsourcing do
    outsourcer { FactoryGirl.create(:organization) }
    provider { FactoryGirl.create(:organization) }
  end
end