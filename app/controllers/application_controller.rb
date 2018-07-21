class ApplicationController < ActionController::Base
  include EntryPoint2018::Exceptions

  protect_from_forgery with: :exception

  rescue_from Forbidden, with: :handle_403
  rescue_from Unauthorized, with: :handle_401
  rescue_from BadRequest, with: :handle_400

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    added_attrs = %i[username email password password_confirmation remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  private

  def handle_403(error)
    @exception = error
    render file: Rails.root.join('public', '403.html'), layout: false, status: :forbidden
  end

  def handle_401(error)
    @exception = error
    redirect_to new_user_session_path, notice: 'login required'
  end

  def handle_400(error)
    @exception = error
    render file: Rails.root.join('public', '400.html'), layout: false, status: :bad_request
  end
end
