class Organization < ActiveRecord::Base
  has_many :employees
end