class Users::UserAuthsController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  include UserAuthControllable

  def show
    @user_auth = UserAuth.find_by!(provider: params[:provider], confirmation_token: params[:confirmation_token])
    @user_auth.confirm_by_token!
    redirect_to new_user_session_path, notice: t('.confirmed')
  rescue UserAuth::ConfirmationExpired
    redirect_to root_path, alert: t('.confirmation_period_expired')
  end

  def new
    @user_auth ||= current_user.user_auths.build(provider: params[:provider] || :email)
  end

  def edit
    @user_auth ||= current_user.user_auths.find_by!(provider: params[:provider])
  end

  # def create
  # end

  # def destroy
  # end

  private

  def after_create_external_user_auth
    redirect_to send(
      "user_#{@user_auth.provider}_omniauth_authorize_path", confirmation_token: @user_auth.confirmation_token
    )
  end

  def after_carete_and_send_confirmation_email
    redirect_to authenticated_root_path, notice: t('.sent_mail')
  end

  def after_create_failure
    flash.now[:alert] = @user_auth.errors.full_messages.join(',')
    render :new
  end

  def after_destroy_success
    flash[:notice] = t('.delete_user_auth', provider: params[:provider].capitalize)
    redirect_to authenticated_root_path
  end

  def after_destroy_failure
    render :edit
  end
end
