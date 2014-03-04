FactoryGirl.define do
  factory :organization do
    sequence(:name) {|n| "organization #{n}"}
    factory :organization_with_employees do
      ignore do
        employees_count 5
      end

      after(:create) do |organization, evaluator|
        create_list(:employee_with_entities, evaluator.employees_count,
                    organization: organization)
      end
    end
  end
end