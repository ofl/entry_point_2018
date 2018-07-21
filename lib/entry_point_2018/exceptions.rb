# https://qiita.com/r7kamura/items/2e88adbdd1782277b2e7

module EntryPoint2018
  class ExceptionHandler
    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        @app.call(env)
      rescue StandardError => error
        EntryPoint2018::ErrorUtility.log_and_notify(error)

        raise Exceptions.for_api(error), error.message
      end
    rescue EntryPoint2018::Exceptions::Base => error
      error.to_rack_response
    end
  end

  class Exceptions
    API_ERROR_TYPES = %w(bad_request unauthorized forbidden not_found unprocessable_entity).freeze

    class << self
      def for_api(error)
        Object.const_get(exception_class_name(error))
      end

      private

      def exception_class_name(error)
        "EntryPoint2018::Exceptions::#{error_type(error.class.to_s).to_s.classify}"
      end

      def error_type(error_class_name)
        custom_error(error_class_name) || registered_error(error_class_name) || 'internal_server_error'
      end

      # ActionDispatch::ExceptionWrapper.rescue_responsesはdefaultが:internal_server_error
      def registered_error(error_class_name)
        error_type = ActionDispatch::ExceptionWrapper.rescue_responses[error_class_name]
        valid_error_type(error_type.to_s)
      end

      def custom_error(error_class_name)
        error_type = error_class_name.split('::').last.underscore
        valid_error_type(error_type.to_s)
      end

      def valid_error_type(error_type)
        API_ERROR_TYPES.include?(error_type) ? error_type : nil
      end
    end

    class Base < StandardError
      def to_rack_response
        [status_code, headers, [body]]
      end

      def to_graphql_extensions
        { code: type, exception: exception }
      end

      private

      def status_code
        Rack::Utils::SYMBOL_TO_STATUS_CODE[type.to_sym]
      end

      def headers
        { 'Content-Type' => 'application/json' }
      end

      def body
        { message: message, type: type }.to_json
      end

      # MyApp::Exceptions::NotFoundに対して'Not Found'が返る
      def error_message
        type.titleize
      end

      # MyApp::Exceptions::NotFoundに対して'not_found'が返る
      def type
        self.class.to_s.split('::').last.underscore
      end

      def exception
        {}
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

  class ErrorUtility
    def self.log_and_notify(error)
      Rails.logger.error error.class
      Rails.logger.error error.message
      Rails.logger.error error.backtrace.join("\n")
      # Bugsnag.notify error
    end
  end
end
