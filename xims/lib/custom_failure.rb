class CustomFailure < Devise::FailureApp
  def respond
    json_failure
    #if request.format == :json
    #  json_failure
    #else
    #  super
    #end
  end

  def json_failure
    self.status = 401
    self.content_type = 'json'
    self.response_body = '{"failed": "FAILED"}'
  end
end