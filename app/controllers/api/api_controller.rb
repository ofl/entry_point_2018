class Api::ApiController < ActionController::API
  NotAuthorized = Class.new(StandardError)
  Forbidden = Class.new(StandardError)
  BadRequest = Class.new(StandardError)

  before_action :require_valid_token

  rescue_from Exception, with: :handle_500
  rescue_from ActiveRecord::RecordInvalid, with: :handle_422
  rescue_from BadRequest, with: :handle_400
  rescue_from ActionController::RoutingError, with: :handle_404
  rescue_from ActiveRecord::RecordNotFound, with: :handle_404
  rescue_from ActiveRecord::RecordNotUnique, with: :handle_409
  # rescue_from Koala::Facebook::AuthenticationError, with: :handle_401
  # rescue_from Twitter::Error::Unauthorized, with: :handle_401
  rescue_from NotAuthorized, with: :handle_401
  rescue_from Forbidden, with: :handle_403

  private

  def handle_500(exception = nil)
    error_handler(exception, code: 500, desc: 'Server Error')
  end

  def handle_422(exception = nil)
    error_handler(exception, code: 422, desc: 'Unprocessable Entity')
  end

  def handle_400(exception = nil)
    error_handler(exception, code: 400, desc: 'Bad Request')
  end

  def handle_401(exception = nil)
    error_handler(exception, code: 401, desc: 'Unauthorized')
  end

  def handle_403(exception = nil)
    error_handler(exception, code: 403, desc: 'Forbidden')
  end

  def handle_404(exception = nil)
    error_handler(exception, code: 404, desc: 'Not Found')
  end

  def handle_409(exception = nil)
    error_handler(exception, code: 409, desc: 'Not Unique Record')
  end

  def require_valid_token
    token = request.headers[:Authorization]
    user = User.find_by(username: request.headers[:username])

    raise NotAuthorized if !user || !Devise.secure_compare(user.authentication_token, token)
    # env['devise.skip_trackable'] = true
    sign_in user, store: false
  end

  def error_handler(exception, code:, desc:)
    message = exception&.message || 'Unknown'
    logger.info "Rendering #{code} with exception: #{message}" if exception
    render json: { desc: desc, errors: [message] }, status: code
  end
end
