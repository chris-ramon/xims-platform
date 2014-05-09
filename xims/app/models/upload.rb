class Upload < ActiveRecord::Base
  belongs_to :uploaded_by, class_name: 'User'
end
