class EmployeesController < ApplicationController
  before_filter :authenticate_user!

  def index
    params.permit(:page)

    finder = Employee
      .where(organization_id: params[:organization_id])
      .page(params[:page])
    employee = finder.first
    guardian.ensure_can_see!(employee)
    metadata = {page: params[:page].to_i,
                total_pages: finder.total_pages.to_i}
    render json: {data: finder,
                  metadata: metadata}
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