class Mypage::AvatarController < ApplicationController
  before_action :authenticate_user!
  layout 'signup'

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(avatar_params)
      redirect_to authenticated_root_path, notice: t('.success')
    else
      render 'edit'
    end
  end

  def destroy
    @user = current_user

    if @user.update(avatar: nil)
      redirect_to authenticated_root_path, notice: t('.success')
    else
      render 'edit'
    end
  end

  private

  def avatar_params
    params.require(:user).permit(:avatar)
  end
end
