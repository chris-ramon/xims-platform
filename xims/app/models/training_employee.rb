class TrainingEmployee < ActiveRecord::Base
  belongs_to :employee
  belongs_to :training
  validates :employee_id, presence: true
end