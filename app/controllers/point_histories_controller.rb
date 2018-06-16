class PointHistoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @point_histories = current_user.point_histories.order(created_at: :desc).page(params[:page])
  end

  def show
    @point_history = current_user.point_histories.find(params[:id])
  end

  def create
    point_amount = rand(1..100)
    current_user.get_point!(point_amount)

    redirect_to point_histories_path, flash: { success: t('.got_point', amount: point_amount) }
  end
end
