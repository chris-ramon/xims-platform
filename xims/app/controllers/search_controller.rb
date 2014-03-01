class SearchController < ApplicationController
  before_filter :authenticate_user!

  def employees
    individuals = Individual.search search_params,
                                    page: params[:page],
                                    per_page: Kaminari.config.default_per_page
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