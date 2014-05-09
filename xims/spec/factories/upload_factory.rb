FactoryGirl.define do
  factory :upload do
    sequence(:original_filename) { |n| "#{n}_name" }
    filesize { 1 }
    sequence(:url) { |n| "#{n}_url" }
    uploaded_by { FactoryGirl.create(:user) }
  end
end