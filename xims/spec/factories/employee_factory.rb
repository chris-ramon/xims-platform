FactoryGirl.define do
  factory :employee do
    organization { FactoryGirl.create(:organization) }
    individual { FactoryGirl.create(:individual) }
    workspace { FactoryGirl.create(:workspace) }
    occupation { FactoryGirl.create(:occupation) }
  end
end