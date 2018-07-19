class Api::ApiController < ActionController::API
  # APIの例外処理はlib/entry_point_2018/exceptions.rbにて行う
  Unauthorized = Class.new(StandardError)
  Forbidden = Class.new(StandardError)
  BadRequest = Class.new(StandardError)

  before_action :require_valid_token

  def require_valid_token
    token = request.headers[:Authorization]
    user = User.find_by(username: request.headers[:username])

    raise Unauthorized if !user || !Devise.secure_compare(user.authentication_token, token)
    # env['devise.skip_trackable'] = true
    sign_in user, store: false
  end
end
