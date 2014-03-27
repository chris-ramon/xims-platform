class EmployeeSerializer < ApplicationSerializer

  attributes :id,
             :id_number,
             :age,
             :first_name,
             :middle_name,
             :last_name,
             :second_last_name,
             :display_name,
             :workspace,
             :occupation,
             :risk_insurance,
             :medical_exam
  has_one :organization, serializer: OrganizationSerializer,
          embed: :objects

  def id_number
    object.individual.id_number
  end
  def age
    object.individual.age
  end
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
  def display_name
    "#{first_name} #{middle_name} #{last_name} #{second_last_name}"
  end
  def workspace
    object.workspace.name
  end
  def occupation
    object.occupation.name
  end
  def risk_insurance
    object.risk_insurance ? object.risk_insurance : {}
  end
  def medical_exam
    object.medical_exam ? object.medical_exam : {}
  end
end
