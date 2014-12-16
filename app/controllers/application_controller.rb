class ApplicationController < ActionController::Base
  acts_as_token_authentication_handler_for User, fallback_to_devise: false

  protect_from_forgery with: :null_session

  def restrict_access
    unless token = request.headers["X-User-Token"]
      raise Exception.new("No token provided in headers")
    end

    unless user = User.find_by(authentication_token: token)
      raise Exception.new("No user with this token was found")
    end

    true
  end

  rescue_from Exception do |exception|
    error_message = { error: exception.inspect }

    respond_to do |format|
      format.json { render json: error_message, status: 401 }
    end
  end

  def json_api_response(response)
    return respond_to do |format|
      format.json { render(
        status: response[:status],
        json: response[:object],
        message: response[:message],
      )}
    end
  end
end
