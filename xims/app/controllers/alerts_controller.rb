class AlertsController < ApplicationController
  before_filter :authenticate_user!

  def employees
    employees_result = {}
    organization = Organization.where(id: params[:organization_id]).first
    alerts_employee = Alerts::Employee.new(organization, params)

    if Alerts::Employee.types[params[:alert_type].to_i].present?
      method_name = Alerts::Employee.types[params[:alert_type].to_i].to_s
      employees_result = alerts_employee.send(method_name)
    else
      render json: error_json, status: :unprocessable_entity
    end

    employee = employees_result[:employees].first
    guardian.ensure_can_see!(employee)
    data = employees_result[:employees]
    meta = {current_page: params[:page],
            total_items: employees_result[:total_items]}
    render json: {data: data, meta: meta}
  end
end