class PointsController < ApplicationController
  before_action :authenticate_user!

  def index
    @points = current_user.points.order(created_at: :desc).page(params[:page])
  end

  def show
    @point = current_user.points.find(params[:id])
  end

  def create
    point_amount = rand(1..100)
    current_user.get_point!(point_amount)

    redirect_to points_path, flash: { success: t('.got_point', amount: point_amount) }
  end
end
