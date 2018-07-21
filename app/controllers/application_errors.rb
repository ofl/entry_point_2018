module ApplicationErrors
  extend ActiveSupport::Concern

  included do
    class Base < ActionController::ActionControllerError
      def initialize(error_message = nil)
        message = error_message || I18n.t("application_errors.#{self.class.to_s.split('::').last.underscore}")
        super(message)
      end
    end

    # 400
    class BadRequest < Base
    end

    # 401
    class Unauthorized < Base
    end

    # 403
    class Forbidden < Base
    end

    # 404
    class NotFound < Base
    end

    # 422
    class UnprocessableEntity < Base
    end

    # 500
    class InternalServerError < Base
    end
  end
end
