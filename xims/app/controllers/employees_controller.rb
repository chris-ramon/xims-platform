class EmployeesController < ApplicationController
  before_filter :authenticate_user!

  def index
    params.permit(:organization_id, :page)

    finder = Employee
      .with_individual
      .where(organization_id: params[:organization_id])
      .page(params[:page])

    guardian.ensure_can_see!(finder.first)
    meta = {current_page: finder.current_page,
            total_items: finder.total_count}
    render json: {data: finder,
                  meta: meta}
  end

  def show
    employee = Employee.where(id: params[:employee_id]).first
    guardian.ensure_can_see!(employee)

    if employee.present?
      render json: employee
    else
      render json: error_json, status: :not_found
    end
  end

  def update
    params.permit(:employee_id)
    errors = []

    employee = Employee.where(id: params[:employee_id]).first
    guardian.ensure_can_see!(employee)

    Employee.transaction do
      risk_insurance = employee.risk_insurance
      if risk_insurance.present? && risk_insurance_params.has_key?(:risk_insurance)
        risk_insurance.expiration_date = risk_insurance_params['risk_insurance']['expiration_date'].to_datetime
        unless risk_insurance.save
          errors << employee.errors
          raise ActiveRecord::Rollback.new
        end
      end

      medical_exam = employee.medical_exam
      if medical_exam.present? && medical_exam_params.has_key?(:medical_exam)
        medical_exam.expiration_date = medical_exam_params['medical_exam']['expiration_date'].to_datetime
        unless medical_exam.save
          errors << employee.errors
        end
      end
    end

    if errors.empty?
      render json: employee
    else
      render json: errors, status: :unprocessable_entity
    end
  end

  private
    def risk_insurance_params
      params.require(:employee).permit(risk_insurance: [:expiration_date])
    end
    def medical_exam_params
      params.require(:employee).permit(medical_exam: [:expiration_date])
    end
end