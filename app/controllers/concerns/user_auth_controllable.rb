module UserAuthControllable
  extend ActiveSupport::Concern

  def create
    @user_auth = find_or_initialize_user_auth
    @user_auth.add_confirmation_token

    if @user_auth.save(context: :need_password)
      @user_auth.external_auth_provider? ? verify_via_auth_provider : verify_via_email
    else
      after_create_failure
    end
  end

  def destroy
    @user_auth = current_user.user_auths.find_by!(provider: params[:provider])
    @user_auth.user_password = user_auth_params[:user_password]

    if @user_auth.valid?(:need_password)
      @user_auth.destroy
      after_destroy_success
    else
      after_destroy_failure
    end
  end

  private

  def user_auth_params
    params.require(:user_auth).permit(:provider, :uid, :user_password)
  end

  def verify_via_auth_provider
    after_create_external_user_auth
  end

  def verify_via_email
    @user_auth.send_confirmation_instructions
    after_carete_and_send_confirmation_email
  end

  def find_or_initialize_user_auth
    user_auth = current_user.user_auths.find_or_initialize_by(provider: user_auth_params[:provider])
    user_auth.user_password = user_auth_params[:user_password]
    user_auth.uid = user_auth_params[:uid] if user_auth.email?
    user_auth
  end
end
