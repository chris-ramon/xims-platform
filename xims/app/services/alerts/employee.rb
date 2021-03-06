module Alerts
  class Employee
    def self.types
      @types ||= Enum.new(:risk_insurance_expired,
                          :medical_exam_expired,
                          :no_induction_training)
    end

    # Parameters
    #   opts :  {page: int, only_ids: boolean}
    #
    #   When *only_ids* is true
    #     it will only return the ids of the individuals.
    #
    def initialize(organization, opts={})
      @organization = organization
      @opts = opts
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
      employees = ::Employee
        .with_individual
        .joins("LEFT JOIN training_employees ON training_employees.id = employees.id")
        .joins("LEFT JOIN trainings ON trainings.id = employees.id")
        .where("(trainings.training_type != ? OR trainings.training_type is null) and employees.organization_id = ?",
               Training.types[:induction], @organization.id)
        .page(@opts[:page])
      employees_result(employees)
    end

    def get_by_alert_type(alert_type)
      method_name = Alerts::Employee.types[alert_type.to_i].to_s
      send(method_name)
    end

    private
    def employees(finder)
      ids = finder.map {|f| f.employee_id }
      employees = ::Employee.with_individual
        .where(id: ids)
        .page(@opts[:page])
      employees_result(employees)
    end

    def employees_result(employees)
      if @opts[:only_ids]
        employees.map {|e| e.individual_id }
      else
        {employees: employees, total_items: employees.total_count}
      end
    end
  end
end
