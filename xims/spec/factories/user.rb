FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@gmail.com" }
    password 'super_secure_password'
    factory :user_with_employee do
      employee { FactoryGirl.create(:employee) }
    end
  end
end
