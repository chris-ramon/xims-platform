class EmployeeSerializer < ApplicationSerializer
  attributes :id,
             :first_name,
             :middle_name,
             :last_name,
             :second_last_name
  def first_name
    object.individual.first_name
  end
  def middle_name
    object.individual.try(:middle_name)
  end
  def last_name
    object.individual.last_name
  end
  def second_last_name
    object.individual.try(:second_last_name)
  end
end
