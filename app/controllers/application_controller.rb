class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  def after_sign_in_path_for(resource)
    tweets_path
  end

  def record_not_found
    render plain: "404 Not Found", status: :not_found
  end
end
