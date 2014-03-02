class Individual < ActiveRecord::Base
  searchkick
  has_one :employee

  def search_data
    attributes.merge(
        organization_id: employee.try(:organization_id)
    )
  end
end