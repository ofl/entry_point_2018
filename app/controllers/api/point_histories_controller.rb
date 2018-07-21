class Api::PointHistoriesController < Api::ApiController
  def index
    # point_histories = current_user.point_histories.order(created_at: :desc).page(params[:page])
    point_histories = current_user.point_histories.order(created_at: :desc)
    render json: point_histories
  end

  def show
    point_history = PointHistory.find(params[:id])
    raise Forbidden unless point_history.user == current_user

    render json: point_history
  end
end
