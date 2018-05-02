class Mypage::AvatarController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.avatar.attach(params.dig(:user, :avatar))

    redirect_to authenticated_root_path, notice: t('.success')
  end
end
