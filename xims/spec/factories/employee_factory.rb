FactoryGirl.define do
  sequence(:first_name) { |n| "first_name #{n}" }

  factory :organization do
    name 'organization abc'
  end

  factory :individual do
    sequence(:id_number) { |n| "#{n}0000000" }
    sequence(:first_name) { |n| "first_name #{n}" }
    sequence(:middle_name) { |n| "middle_name #{n}" }
    sequence(:last_name) { |n| "last_name #{n}" }
  end

  factory :workspace do
    name 'it'
  end

  factory :occupation do
    name 'coder'
  end

  factory :employee do
    organization
    individual
    workspace
    occupation
  end
end