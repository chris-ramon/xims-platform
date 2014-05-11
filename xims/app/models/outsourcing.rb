class Outsourcing < ActiveRecord::Base
  belongs_to :outsourcer, class_name: 'Organization'
  belongs_to :provider, class_name: 'Organization'
end