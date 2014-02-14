class Employee < ActiveRecord::Base
  belongs_to :organization
  belongs_to :individual
  belongs_to :workspace
  belongs_to :occupation
end