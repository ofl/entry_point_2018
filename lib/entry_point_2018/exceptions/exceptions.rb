module EntryPoint2018
  module Exceptions
    API_ERROR_TYPES = %w(bad_request unauthorized forbidden not_found unprocessable_entity).freeze

    class Base < StandardError
      include ErrorBase
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
      def initialize(error_message = nil, record = nil)
        message = error_message || I18n.t("application_errors.#{self.class.to_s.split('::').last.underscore}")
        @record = record
        super(message)
      end

      def body
        { errors: ErrorSerializer.new(@record, message, status, code).serialized_json }.to_json
      end
    end

    # 500
    class InternalServerError < Base
    end

    module ModuleMethods
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

    extend ModuleMethods
  end
end
