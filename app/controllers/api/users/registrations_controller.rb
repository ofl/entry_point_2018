class Api::Users::RegistrationsController < Api::ApiController
  skip_before_action :require_valid_token, only: :create

  def show
    render json: current_user, serializer: RegistrantSerializer
  end

  def create
    user = User.new(user_params)
    user.save!
    sign_in :user, user

    render json: user, serializer: RegistrantSerializer
  end

  def update
    current_user.update!(user_params)

    render json: current_user, serializer: RegistrantSerializer
  end

  def destroy
    current_user.destroy
    sign_out(:user)

    render json: { head: :ok }
  end

  private

  def user_params
    params.require(:user).permit(
      :username, :email, :password
    )
  end
end
