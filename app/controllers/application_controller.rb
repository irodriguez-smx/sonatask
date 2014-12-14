class ApplicationController < ActionController::Base
  acts_as_token_authentication_handler_for User, fallback_to_devise: false

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  
  
  def restrict_access
    if (user = User.where(:authentication_token=> request.headers["X-User-Token"]).first) && (user.email == request.headers["X-User-Email"])
      true
    else
      res = {:error => "Unauthenticated request"}
      respond_to do |format|      
        format.json { render json: res, :status => 401 }
      end
    end
  end

  def json_api_response
    respond_to do |format|
      format.json { render json: @response, :status => @response[:status] }
    end
  end
end
