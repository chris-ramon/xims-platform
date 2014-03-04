require 'spec_helper'


describe EmployeeAlerts do
  let(:abc_organization) { create(:organization_with_employees, employees_count: 3) }
  let(:other_organization) { create(:organization_with_employees, employees_count: 3) }
  let(:employee_alerts) { EmployeeAlerts.new(abc_organization) }
  before do
    abc_organization.employees.to_a.each do |employee|
      risk_insurance = employee.risk_insurances.first
      risk_insurance.expiration_date = Date.today - 50.days
      risk_insurance.save

      medical_exam = employee.medical_exams.first
      medical_exam.expiration_date = Date.today - 50.days
      medical_exam.save

      Training.where(id: employee.training_ids)
        .update_all(training_type: Training.types[:training])
    end
    other_organization.employees.to_a.each do |employee|
      risk_insurance = employee.risk_insurances.first
      risk_insurance.expiration_date = Date.today - 50.days
      risk_insurance.save

      medical_exam = employee.medical_exams.first
      medical_exam.expiration_date = Date.today - 50.days
      medical_exam.save
    end
  end
  describe 'risk_insurance_expired' do
    context 'when there are employees with ri expired' do
      it 'filters by the given organization' do
        employee_alerts.risk_insurance_expired
          .length.should == 3
      end
      it 'returns the correct attributes' do
        first = employee_alerts.risk_insurance_expired[0]
        first.should respond_to('id')
        first.should respond_to('id_number')
        first.should respond_to('first_name')
        first.should respond_to('middle_name')
        first.should respond_to('last_name')
        first.should respond_to('second_last_name')
      end
    end
  end
  describe 'medical_exam_expired' do
    context 'when there are employees with me expired ' do
      it 'filters by the given organization' do
        employee_alerts.medical_exam_expired
          .length.should == 3
      end
    end
  end
  describe 'no_induction_training' do
    context 'when there are employees without induction training' do
      it 'filters by the given organization' do
        employee_alerts.no_induction_training
          .length.should == 3
      end
    end
  end
end
