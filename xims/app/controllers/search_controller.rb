class SearchController < ApplicationController
  before_filter :authenticate_user!

  def employees
    params.permit(:term, :alert_type)

    opts = {
        page: params[:page],
        per_page: Kaminari.config.default_per_page,
        where: {organization_id: current_user.employee.organization_id}
    }

    if params[:alert_type]
      employee_alerts = Alerts::Employee.new(
          current_user.employee.organization, only_ids: true)

      ids = employee_alerts.get_by_alert_type(params[:alert_type])
      raise Xims::NotFound if ids.empty?

      opts[:where] = opts[:where].merge({id: ids})
    end

    individuals = Individual.search search_params, opts
    meta = {total_items: individuals.total,
            current_page: params[:page].to_i}
    response = {data: individuals,
                meta: meta}
    render json: response
  end

  private
    def search_params
      params.require(:term)
    end
end