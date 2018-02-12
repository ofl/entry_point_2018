class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :authenticate_user!, if: :need_authenticate?
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  def twitter
    callback_from :twitter
  end

  def facebook
    callback_from :facebook
  end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end

  private

  def callback_from(provider)
    provider = provider.to_s
    auth = request.env['omniauth.auth']

    if callback_params['confirmation_token']
      connect_with(provider: provider, auth: auth, confirmation_token: callback_params['confirmation_token'])
    elsif callback_params['reset_password']
      reset_password_with(provider: provider, auth: auth)
    else # TODO: 制限の追加
      sign_in_with(provider: provider, auth: auth)
    end
  end

  # Socila認証を利用したログイン
  def sign_in_with(provider:, auth:)
    user_auth = UserAuth.confirmed.find_by(provider: provider, uid: auth.uid)

    if user_auth.present?
      user_auth.confirme!
      flash_authenticate_success(provider)
      sign_in_and_redirect user_auth.user
    else
      flash_authenticate_failure(provider)
      redirect_to new_user_session_path
    end
  end

  # Socila認証を追加（ユーザー登録、認証追加時）
  def connect_with(provider:, auth:, confirmation_token:) # rubocop:disable Metrics/MethodLength
    user_auth = find_user_auth(provider, auth, confirmation_token)

    # forbidden error if user_auth is not user's
    if current_user != user_auth&.user
      flash_authenticate_not_match(provider)
    elsif user_auth.confirmation_time_out?
      flash_confirmation_time_out
    else
      user_auth.uid = auth.uid
      user_auth.confirme!
      flash_authenticate_success(provider)
    end

    redirect_to root_path
  end

  def reset_password_with(provider:, auth:)
    user_auth = UserAuth.confirmed.find_by(provider: provider, uid: auth.uid)
    raise BadRequest if user_auth.nil?

    redirect_to edit_user_password_path(reset_password_token: user_auth.user.raw_reset_password_token)
  end

  def callback_params
    Rails.env.test? ? request.env['omniauth.test_params'] : request.env['omniauth.params']
  end

  def need_authenticate?
    return false if callback_params.blank?
    callback_params['confirmation_token'].present?
  end

  def flash_authenticate_success(provider)
    flash[:notice] = t('devise.omniauth_callbacks.success', provider: provider.capitalize)
  end

  def flash_authenticate_failure(provider)
    flash[:alert] = t('.failure', provider: provider.capitalize)
  end

  def flash_authenticate_not_match(provider)
    flash[:alert] = t('.not_match', provider: provider.capitalize)
  end

  def flash_confirmation_time_out
    flash[:alert] = t('.confirmation_period_expired')
  end

  def find_user_auth(provider, auth, confirmation_token)
    user_auth = UserAuth.confirmed.find_by(provider: provider, uid: auth.uid) ||
                UserAuth.find_by(provider: provider, confirmation_token: confirmation_token)
    raise BadRequest if user_auth.nil?
    user_auth
  end
end
