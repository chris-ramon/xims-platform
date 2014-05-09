class TrainingsController < ApplicationController
  before_filter :authenticate_user!

  def index
    params.permit(:organization_id, :page)

    finder = Training
      .where(organization_id: params[:organization_id])
      .page(params[:page])

    guardian.ensure_can_see!(finder.first) if finder.present?

    meta = {current_page: finder.current_page,
            total_items: finder.total_count}
    finder_serializer = ActiveModel::ArraySerializer.new(
        finder, each_serializer: TrainingSerializer)
    render json: {data: finder_serializer,
                  meta: meta}
  end

  def show
    training = Training.where(id: params[:training_id]).first
    guardian.ensure_can_see!(training)
    render json: training
  end

  def create
    organization = Organization.where(id: params[:organization_id]).first
    guardian.ensure_can_create!(Training, organization)
    training_creator = TrainingCreator.new(current_user, training_params)
    training = training_creator.create

    if training_creator.errors.present?
      render json: training_creator.errors, status: :unprocessable_entity
    else
      render json: training
    end
  end

  private
    def training_params
      permitted = [
          :responsible_id, :trainer_id, :training_type,
          :training_date, :training_hours, :topic,
          {employees: [:id, :observations]}]
      training_params = params.require(:training).permit(*permitted)
      training_params.merge({organization_id: params[:organization_id]})
    end
end
