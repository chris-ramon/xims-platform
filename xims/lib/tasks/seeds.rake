namespace :seeds do
  task 'risk_insurance_expired', [:organization_id] => :environment do |t, args|
    risk_insurance = TestFacades::RiskInsurance.new(
        args.organization_id)
    risk_insurance.expired
  end
  task 'employees', [:organization_id, :count] => :environment do |t, args|
    organization = Organization.where(id: args.organization_id).first
    (args.count).to_i.times { FactoryGirl.create(:employee, organization: organization) }
  end
end
