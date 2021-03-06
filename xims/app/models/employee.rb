class Employee < ActiveRecord::Base
  belongs_to :organization
  belongs_to :individual
  belongs_to :workspace
  belongs_to :occupation

  has_many :risk_insurances
  has_many :medical_exams
  has_many :training_employees
  has_many :trainings, through: :training_employees

  scope :with_individual, -> {
    joins(:individual)
      .select('employees.id', 'employees.organization_id',
              'individuals.id AS individual_id', 'individuals.id_number',
              'individuals.first_name', 'individuals.middle_name',
              'individuals.last_name', 'individuals.second_last_name')
  }

  def risk_insurance
    risk_insurances.where(active: true).first
  end

  def medical_exam
    medical_exams.where(active: true).first
  end
end