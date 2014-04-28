class RiskInsurance < ActiveRecord::Base
  belongs_to :employee
  validates :expiration_date, presence: true
end