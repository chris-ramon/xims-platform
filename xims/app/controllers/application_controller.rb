class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def success_json
    {success: 'OK'}
  end

  def error_json
    {failed: 'FAILED'}
  end

  def guardian
    @guardian ||= Guardian.new(current_user)
  end

  rescue_from Xims::InvalidAccess do
    render json: error_json, status: :unauthorized
  end

end
