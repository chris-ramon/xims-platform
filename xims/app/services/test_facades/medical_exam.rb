module TestFacades
  class Training
    def initialize(organization_id, employees_count=5)
      @organization = Organization.where(id: organization_id)
      @employees_count = employees_count
    end
    def expired
      @employees_count.times do
        employee = FactoryGirl.create(:employee, organization: @organization)
        medical_exam = FactoryGirl.create(
            :medical_exam, employee: employee)
        medical_exam.expiration_date = Date.today - 50.days
        medical_exam.save
      end
    end
  end
end