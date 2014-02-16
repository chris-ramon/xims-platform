class EmployeesController < ApplicationController
  before_filter :authenticate_user!

  def index
    params.permit(:organization_id)
    params.permit(:page)

    params.require(:organization_id)

    finder = Employee.where(organization_id: params[:organization_id])
    employee = finder.first
    guardian.ensure_can_see!(employee)

    if finder.present?
      finder = finder.page params[:page]
      render json: {data: finder, metadata: {page: params[:page]}}
    else
      render json: {data: finder, metadata: {}}
    end
  end

end