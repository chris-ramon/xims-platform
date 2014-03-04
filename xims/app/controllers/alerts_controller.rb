class AlertsController < ApplicationController
  before_filter :authenticate_user!

  def employees
    render json: :nothing
    #organization = Organization.where(id: params[:organization_id]).first
    #employee_alerts = EmployeeAlerts.new (organization)
    #guardian.ensure_can_see!(employee)
    #meta = {}
    #render json: {data: data}
  end
end