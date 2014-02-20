class TrainingEmployeesController < ApplicationController
  before_filter :authenticate_user!

  def index_employees
    training = Training
      .select('trainings.organization_id')
      .where(id: params[:training_id])
      .first
    finder = TrainingEmployee
      .joins({employee: 'individual'})
      .select('individuals.id_number', 'individuals.first_name',
              'individuals.last_name', 'training_employees.observations')
      .where(training_id: params[:training_id])
      .page(params[:page])
    guardian.ensure_can_see!(training)
    render json: {data: finder,
                  metadata: {page: params[:page].to_i, total_pages: finder.total_pages}}
  end

  def index_trainings
    employee = Employee
      .where(id: params[:employee_id])
      .first
    finder = TrainingEmployee
      .joins(:training)
      .select('trainings.topic', 'trainings.training_hours',
              'trainings.training_date', 'trainings.training_type')
      .where(employee_id: params[:employee_id])
      .page(params[:page])
    guardian.ensure_can_see!(employee)
    metadata = {page: params[:page].to_i,
                total_pages: finder.total_pages}
    render json: {data: finder, metadata: metadata}
  end
end