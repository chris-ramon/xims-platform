require 'guardian/ensure_magic'

class Guardian
  include EnsureMagic

  def initialize(user)
    @user = user
  end

  def can_create?(klass, parent=nil)
    target = klass.name.underscore
    if parent.present?
      #return false unless can_see?(parent)
      target << "_on_#{parent.class.name.underscore}"
    end
    create_method = :"can_create_#{target}?"

    return send(create_method, parent) if respond_to?(create_method)

    false
  end

  def can_see?(obj)
    if obj
      see_method = method_name_for :see, obj
      (see_method ? send(see_method, obj) : false)
    end
  end

  def method_name_for(action, obj)
    method_name = :"can_#{action}_#{obj.class.name.underscore}?"
    method_name if respond_to?(method_name)
  end

  def can_see_employee?(employee)
    @user.employee.organization_id == employee.organization_id
  end

  def can_see_training?(training)
    @user.employee.organization_id == training.organization_id
  end

  def can_create_training_on_organization?(organization)
    @user.employee.organization_id == organization.id
  end
end