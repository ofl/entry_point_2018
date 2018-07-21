class Api::Users::SessionsController < Api::ApiController
  skip_before_action :require_valid_token, only: :create

  def create
    user = params[:user] ? verify_via_username_and_password : verify_via_auth_provider

    if current_user
      raise BadRequest if current_user != user
    else
      sign_in(:user, user)
    end
    user.update_authentication_token!

    render json: { authentication_token: user.authentication_token }
  end

  def destroy
    current_user.reset_authentication_token!
    sign_out current_user

    render json: { head: 200 }
  end

  private

  def verify_via_username_and_password
    user = User.find_by!(username: user_params[:username])
    raise BadRequest unless user.valid_password?(user_params[:password])
    user
  end

  def verify_via_auth_provider
    user_auth = UserAuth.find_by!(provider: user_auth_params[:provider], uid: user_auth_params[:uid])
    raise BadRequest unless user_auth.verified_by_auth_provider?(user_auth_params)
    user_auth.user
  end

  def user_params
    params.require(:user).permit(
      :username, :password
    )
  end

  def user_auth_params
    params.require(:user_auth).permit(
      :provider, :uid, :access_token, :access_secret
    )
  end
end
