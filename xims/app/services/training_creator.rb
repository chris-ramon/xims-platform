class TrainingCreator

  attr_reader :errors, :opts

  # Parameters
  #   opts :  {training: {}, employees: []}
  #     training:
  #       - responsible_id        : Individual id
  #       - trainer_id            : Individual id
  #       - training_type         : Training.type
  #       - training_date         : Time
  #       - topic                 : string
  #
  #     employees:                : array of hashes
  #        - id                   : Employee id
  #        - observations         : string
  def initialize(user, opts)
    @user = user
    @opts = opts || {}
    @employees_params = @opts.delete :employees
    @training = nil
    @errors = []
  end

  def create
    Training.transaction do
      setup_training
      save_training
      save_employees
    end
    @training
  end

  def setup_training
    @training = Training.new(@opts)
  end

  def save_training
    unless @training.save
      @errors = @training.errors
      raise ActiveRecord::Rollback.new
    end
  end

  def save_employees
    @employees_params.each do |employee|
      training_employee = TrainingEmployee.new(
        {training_id: @training.id,
        employee_id: employee[:id],
        observations: employee[:observations]})
      unless training_employee.save
        @errors = {employees: training_employee.errors}
        raise ActiveRecord::Rollback.new
      end
    end
  end
end