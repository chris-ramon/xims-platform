class AlertsController < ApplicationController
  before_filter :authenticate_user!

  def employees
    employees_result = {}
    data = []
    meta = {current_page: params[:page], total_items: 0}
    organization = Organization.where(id: params[:organization_id]).first
    employee_alerts = Alerts::Employee.new(organization, params)

    if Alerts::Employee.types[params[:alert_type].to_i].present?
      employees_result = employee_alerts.get_by_alert_type(params[:alert_type])
    else
      render json: error_json, status: :unprocessable_entity
    end

    employee = employees_result[:employees].first

    if employee.present?
      guardian.ensure_can_see!(employee)
      data = employees_result[:employees]
      meta = meta.merge({total_items: employees_result[:total_items]})
      render json: {data: data, meta: meta}
    else
      render json: {data: data, meta: meta}
    end
  end
end