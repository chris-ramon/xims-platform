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
  task 'organization', [:organization_name] => :environment do |t, args|
    organization = FactoryGirl.create(:organization, name: args.organization_name)
    50.times { FactoryGirl.create(:employee, organization: organization) }
  end
  task 'user', [:organization_id, :email, :password] => :environment do |t, args|
    organization = Organization.where(id: args.organization_id).first
    employee = FactoryGirl.create(:employee, organization: organization)
    user = User.create!({email: args.email,
                         password: args.password,
                         password_confirmation: args.password})
    user.employee = employee
    user.save
  end
end
