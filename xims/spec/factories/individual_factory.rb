FactoryGirl.define do
  factory :individual do
    sequence(:id_number) { |n| "#{n}0".to_i }
    sequence(:first_name) { |n| "first_name #{n}" }
    sequence(:second_last_name) { |n| "second_last_name #{n}" }
    sequence(:last_name) { |n| "last_name #{n}" }
  end
end