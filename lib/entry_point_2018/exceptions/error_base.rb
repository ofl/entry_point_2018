module EntryPoint2018
  module ErrorBase
    def initialize(error_message = nil)
      message = if Rails.env.production?
                  I18n.t("application_errors.#{self.class.to_s.split('::').last.underscore}")
                else
                  error_message || I18n.t("application_errors.#{self.class.to_s.split('::').last.underscore}")
                end
      super(message)
    end

    def to_rack_response
      [status, headers, body]
    end

    def to_graphql_extensions
      {}
    end

    def status
      Rack::Utils::SYMBOL_TO_STATUS_CODE[code.to_sym]
    end

    def error_message
      code.upcase
    end

    private

    # MyApp::Exceptions::NotFoundに対して'not_found'が返る
    def code
      self.class.to_s.split('::').last.underscore
    end

    def headers
      { 'Content-Type' => 'application/json' }
    end

    def body
      { errors: [{ title: message, code: error_message, status: status }] }.to_json
    end
  end
end
