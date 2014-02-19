class TrainingsController < ApplicationController
  before_filter :authenticate_user!

  def index
    params.permit(:page)

    finder = Training
      .where(organization_id: params[:organization_id])
      .page(params[:page])
    training = finder.first
    guardian.ensure_can_see!(training)
    render json: {data: finder, metadata: {page: params[:page].to_i, total_pages: finder.total_pages}}
  end

  def show
    training = Training.where(id: params[:training_id]).first
    guardian.ensure_can_see!(training)
    render json: training
  end

  def create
    params = create_params

    organization = Organization.where(id: params[:organization_id]).first
    guardian.ensure_can_create!(Training, organization)
    training_creator = TrainingCreator.new(current_user, params)
    training_creator.create

    if training_creator.errors.present?
      render json: training_creator.errors
    else
      render json: success_json
    end
  end

  def create_params
    permitted = [
        :organization_id,
        :responsible_id, :trainer_id, :training_type,
        :training_date, :training_hours, :topic,
        {employees: [:id]}]
    params.require(:training).permit(*permitted)
  end
end
