require 'spec_helper'

describe Employee do
  let(:employee) { create(:employee_with_entities) }
  describe 'risk_insurance' do
    it 'returns value' do
      employee.risk_insurance.should be_present
      employee.risk_insurance.class.should == RiskInsurance
    end
  end
  describe 'medical_exam' do
    it 'returns value' do
      employee.medical_exam.should be_present
      employee.medical_exam.class.should == MedicalExam
    end
  end
end