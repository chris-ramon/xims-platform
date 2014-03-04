class Training < ActiveRecord::Base
  belongs_to :organization
  belongs_to :responsible, class_name: 'Individual'
  belongs_to :trainer, class_name: 'Individual'

  has_many :training_employees
  has_many :employees, through: :training_employees

  def self.types
    @types ||= Enum.new(:induction, :training,
                        :coaching, :emergency_drill)
  end
end