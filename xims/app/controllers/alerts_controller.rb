class AlertsController < ApplicationController
  before_filter :authenticate_user!

  def employees
    organization = Organization.where(id: params[:organization_id]).first
    alerts_employee = Alerts::Employee.new(organization)
    data = {}
    if Alerts::Employee.types[params[:alert_type].to_i].present?
      method_name = Alerts::Employee.types[params[:alert_type].to_i].to_s
      employees = alerts_employee.send(method_name)
      employee = employees.first
      guardian.ensure_can_see!(employee)
      data = {method_name: employees}
    end
    meta = {}
    render json: {data: data}
  end
end