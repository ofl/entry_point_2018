class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  REGISTRATION_STEPS = %i(form preview email_form auth_via_email auth_via_twitter auth_via_facebook).freeze

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    build_resource(sign_up_params)
    resource.ensure_dummy_email_address unless registration_step == :auth_via_email

    case registration_step
    when :preview
      validate_resource
    when :auth_via_email, :auth_via_twitter, :auth_via_facebook
      resource.save
      sign_up_and_redirect_to_auth_result(resource)
      return
    end

    resource.email = nil
    render :new
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username email password])
  end

  def after_update_path_for(_resource)
    authenticated_root_path
  end

  def validate_resource
    return if resource.valid?
    clean_up_passwords resource
    set_minimum_password_length
  end

  def registration_step
    @registration_step ||= REGISTRATION_STEPS.find { |step| params[step].present? }
  end

  def auth_provider(step)
    step.to_s.split('_').last
  end

  def sign_up_and_redirect_to_auth_result(resource)
    if resource.persisted?
      user_auth = create_user_auth(auth_provider(registration_step))
      set_flash_message! :notice, :signed_up
      sign_up(resource_name, resource)

      redirect_to_auth_result(resource, user_auth)
    else
      render_error_form(resource)
    end
  end

  def redirect_to_auth_result(resource, user_auth)
    if user_auth.persisted?
      if user_auth.external_auth_provider?
        redirect_to_external_auth_provider(user_auth)
      else
        send_confrimation_mail(user_auth)
        set_flash_message! :notice, :confirmation_mail_sent
        redirect_to after_sign_up_path_for(resource)
      end
    else
      set_flash_message! :notice, :failed_create_user_auth
      redirect_to after_sign_up_path_for(resource)
    end
  end

  def render_error_form(resource)
    # emailのみエラーの場合email_formを表示
    if resource.valid_except_email?
      @registration_step = :email_form
    else
      clean_up_passwords resource
      set_minimum_password_length
    end
    respond_with resource
  end

  def create_user_auth(provider)
    user_auth = resource.user_auths.find_or_initialize_by(provider: provider)
    user_auth.uid = resource.email if provider == 'email'
    user_auth.add_confirmation_token
    user_auth.save
    user_auth
  end

  def redirect_to_external_auth_provider(user_auth)
    redirect_to send(
      "user_#{user_auth.provider}_omniauth_authorize_path", confirmation_token: user_auth.confirmation_token
    )
  end

  def send_confrimation_mail(user_auth)
    AuthenticationMailer.confirmation_instructions(resource, user_auth).deliver_now
  end
end
