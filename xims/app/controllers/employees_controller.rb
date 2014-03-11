class EmployeesController < ApplicationController
  before_filter :authenticate_user!

  def index
    params.permit(:page)

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
end