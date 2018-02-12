class Api::Users::UserAuthsController < Api::ApiController
  include UserAuthControllable

  # def create
  # end

  # def destroy
  # end

  private

  def after_create_external_user_auth
    render json: { message: "Successfully confirmed with #{user_auth_params[:provider]}" }, status: 200
  end

  def after_carete_and_send_confirmation_email
    render json: { message: 'Sent confirmation mail' }, status: 200
  end

  def after_create_failed
    description = @user_auth.errors.full_messages.join(',')
    render json: { message: 'Failed to create user auth', description: description }, status: 400
  end

  def after_destroy
    render json: { head: 200 }
  end

  def after_destroy_failed
    render json: { message: 'Failed to destroy user auth' }, status: 200
  end
end
