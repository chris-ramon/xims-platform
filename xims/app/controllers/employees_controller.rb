class EmployeesController < ApplicationController
  before_filter :authenticate_user!

  def index
    params.permit(:organization_id, :page)

    providers = Outsourcing.where(outsourcer_id: params[:organization_id])
      .pluck('provider_id')
    organization_ids = [params[:organization_id]] + providers

    finder = Employee
      .with_individual
      .where(organization_id: organization_ids)
      .page(params[:page])
      .per(params[:per_page])

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

    risk_insurance = employee.risk_insurance
    if risk_insurance.present?
      if params.require(:employee).has_key?(:risk_insurance)
        unless risk_insurance.update(risk_insurance_params)
          errors << {risk_insurance: risk_insurance.errors.full_messages}
        end
      end
    else
      RiskInsurance.create(risk_insurance_params.merge({employee_id: employee.id, active: true}))
    end

    medical_exam = employee.medical_exam
    if medical_exam.present?
      if params.require(:employee).has_key?(:medical_exam)
        unless medical_exam.update(medical_exam_params)
          errors << {medical_exam: medical_exam.errors.full_messages}
        end
      end
    else
      MedicalExam.create(medical_exam_params.merge({employee_id: employee.id, active: true}))
    end

    if errors.empty?
      render json: employee
    else
      render json: {errors: errors}, status: :unprocessable_entity
    end
  end

  private
    def risk_insurance_params
      params.require(:employee).require(:risk_insurance).permit(:expiration_date)
    end
    def medical_exam_params
      params.require(:employee).require(:medical_exam).permit(:expiration_date)
    end
end