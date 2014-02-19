class TrainingEmployee < ActiveRecord::Base
  belongs_to :employee
  belongs_to :training
end