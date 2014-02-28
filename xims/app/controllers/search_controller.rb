class SearchController < ApplicationController
  def employees
    individuals = Individual.search search_params
    response = {data: individuals}
    render json: response
  end

  private
    def search_params
      params.require(:term)
    end
end