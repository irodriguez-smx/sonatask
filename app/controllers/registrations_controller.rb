class RegistrationsController < Devise::RegistrationsController  
  skip_before_filter :require_no_authentication
  respond_to :json

  #POST /resource
  def create
    build_resource(sign_up_params)
    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      sign_up(resource_name, resource)
      respond_with resource
    else
      clean_up_passwords resource
      @validatable = devise_mapping.validatable?
      if @validatable
        @minimum_password_length = resource_class.password_length.min
      end
      respond_with resource
    end
  end
end  
