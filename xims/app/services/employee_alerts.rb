class EmployeeAlerts
  def initialize(organization)
    @organization = organization
  end

  def risk_insurance_expired
    finder = RiskInsurance
      .select('employee_id')
      .where('employee_id IN (?) AND active = ? AND expiration_date < ?',
             @organization.employee_ids, true, Date.today)
    employees(finder)
  end

  def medical_exam_expired
    finder = MedicalExam
      .select('employee_id')
      .where('employee_id IN (?) AND active = ? AND expiration_date < ?',
             @organization.employee_ids, true, Date.today)
    employees(finder)
  end

  def no_induction_training
    Employee
      .with_individual
      .joins("LEFT JOIN training_employees ON training_employees.id = employees.id")
      .joins("LEFT JOIN trainings ON trainings.id = employees.id")
      .where("(trainings.training_type != ? OR trainings.training_type is null) and employees.organization_id = ?",
             Training.types[:induction], @organization.id)
  end

  private
    def employees(finder)
      ids = finder.map {|f| f.employee_id }
      Employee.with_individual.where(id: ids)
    end
end