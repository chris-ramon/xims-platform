class Incident < ActiveRecord::Base
  belongs_to :incident_type
end