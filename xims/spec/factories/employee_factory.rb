FactoryGirl.define do
  factory :organization do
    sequence(:name) {|n| "organization #{n}"}
  end

  factory :individual do
    sequence(:id_number) { |n| "#{n}0000000".to_i }
    sequence(:first_name) { |n| "first_name #{n}" }
    sequence(:second_last_name) { |n| "second_last_name #{n}" }
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