module UserAuthControllable
  extend ActiveSupport::Concern

  def create
    @user_auth = current_user.user_auths.find_or_initialize_by(user_auth_params)
    @user_auth.user.current_password = current_password

    @user_auth.add_confirmation_token
    @user_auth.external_auth_provider? ? verify_via_auth_provider : verify_via_email
  end

  def destroy
    user_auth = current_user.user_auths.find_by provider: params[:provider], user: current_user
    if user_auth&.destroy
      after_destroy
      return
    end

    after_destroy_failed
  end

  private

  def user_auth_params
    params.require(:user_auth).permit(:provider, :uid)
  end

  def verify_via_auth_provider
    if @user_auth.save
      after_create_external_user_auth
      return
    end

    after_create_failed
  end

  def verify_via_email
    if @user_auth.send_confirmation_instructions
      after_carete_and_send_confirmation_email
      return
    end

    after_create_failed
  end

  def current_password
    params[:user_auth][:user][:current_password]
  end
end
