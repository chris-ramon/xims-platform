class SessionsController < Devise::SessionsController

  def create
    resource = warden.authenticate!(:scope => resource_name,
                                    :recall => "#{controller_path}#failure")
    sign_in(resource_name, resource)
    render json: success_json
  end

  def destroy
    sign_out(resource_name)
    render nothing: true
  end

  def failure
    warden.custom_failure!
    render json: error_json, status: :unprocessable_entity
  end

  def show_current_user
    warden.authenticate!(:scope => resource_name,
                         :recall => "#{controller_path}#failure")
    render json: current_user
  end
end