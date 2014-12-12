class HelperController < ApplicationController
  def index
  end

  def token
    email = params[:username]
    pass = params[:password]
    #if user.nil?
      #user = User.new(:email => params[:email], :password => params[:password], :password_confirmation => params[:password])
      #user.save
    #end
    if email.nil? || pass.nil?
      res = {:errors => (u=User.new;u.save;u.errors), :status=> 400}
    elsif (user = User.authenticate(email,pass)) && (not user.nil?)
      res = {:token=> user.authentication_token,:status=> 200}
    else
      res = {:errors=>'Invalid user credentials', :status=> 400}
    end
    respond_to do |format|
      format.json { render json: res, :status => res[:status] }
    end
 
  end
end
