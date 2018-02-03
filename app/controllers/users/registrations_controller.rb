class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    build_resource(sign_up_params)

    case registration_action
    when :back
      render :new
    when :preview
      preview
    else
      register_user_and_create_user_auth
    end
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
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username password])
  end

  def after_update_path_for(_resource)
    authenticated_root_path
  end

  def preview
    unless resource.valid?
      clean_up_passwords resource
      set_minimum_password_length
    end
    render :new
  end

  def registration_action
    @registration_action ||= %i(back preview email twitter facebook).find do |action_name|
      params[action_name].present?
    end
  end

  def register_user_and_create_user_auth
    resource.save
    if resource.persisted?
      set_flash_message! :notice, :signed_up
      sign_up(resource_name, resource)

      user_auth = create_user_auth
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
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def create_user_auth
    user_auth = resource.user_auths.find_or_initialize_by(provider: registration_action)
    user_auth.uid = resource.email if registration_action == :email
    user_auth.add_confirmation_token
    user_auth.save
    user_auth
  end

  def redirect_to_external_auth_provider(user_auth)
    redirect_to send(
      "user_#{user_auth.provider}_omniauth_authorize_path", connect: user_auth.id
    )
  end

  def send_confrimation_mail(user_auth)
    AuthenticationMailer.confirmation_instructions(resource, user_auth).deliver_now
  end
end
