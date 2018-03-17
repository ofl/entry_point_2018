class PointsController < ApplicationController
  before_action :authenticate_user!

  def index
    @points = current_user.points.order(created_at: :desc).page(params[:page])
  end

  def show
    @point = current_user.points.find(params[:id])
  end

  def create
    current_user.points.create(status: :got, amount: rand(1..100))
    redirect_to points_path
  end
end
