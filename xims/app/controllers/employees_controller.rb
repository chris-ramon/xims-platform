class EmployeesController < ApplicationController
  def index
    params.require(:organization_id)

    employees = Employee.where(organization_id: params[:organization_id])
    render json: employees
  end

end