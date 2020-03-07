# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  private

  # strong parameters for login
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %i[name user_name password password_confirmation])
    devise_parameter_sanitizer.permit(:sign_in,
                                      keys: %i[user_name password])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[name user_name website profile email tel gender])
  end
end
