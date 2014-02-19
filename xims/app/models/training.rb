class Training < ActiveRecord::Base
  TRAINING_TYPE = {induction: 0}

  belongs_to :organization
  belongs_to :responsible, class_name: 'Individual'
  belongs_to :trainer, class_name: 'Individual'
  has_many :training_employees
end