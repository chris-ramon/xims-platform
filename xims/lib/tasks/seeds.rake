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
  task 'user', [:organization_id, :email, :password, :id_number, :first_name,
                :last_name, :second_last_name, :age] => :environment do |t, args|
    organization = Organization.where(id: args.organization_id).first
    individual = FactoryGirl.create(:individual, id_number: args.id_number,
                                    first_name: args.first_name, last_name: args.last_name,
                                    second_last_name: args.second_last_name, age: args.age)
    employee = FactoryGirl.create(:employee, organization: organization, individual: individual)
    user = User.create!({email: args.email,
                         password: args.password,
                         password_confirmation: args.password})
    user.employee = employee
    user.save
  end
end
