module EntryPoint2018
  module ErrorBase
    def initialize(error_message = nil)
      message = error_message || I18n.t("application_errors.#{self.class.to_s.split('::').last.underscore}")
      super(message)
    end

    def to_rack_response
      [status_code, headers, [body]]
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
  end
end
