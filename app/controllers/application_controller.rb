class ApplicationController < ActionController::Base
  include Pundit::Authorization
  skip_forgery_protection
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  after_action :verify_authorized, unless: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :bio, :preferred_timezone, :profile_picture])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :bio, :preferred_timezone, :profile_picture])
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def after_sign_in_path_for(resource)
    programs_path
  end  

  private
    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_back fallback_location: root_url
    end

    def record_not_found
      render 'shared/record_not_found', status: :not_found
    end
end
