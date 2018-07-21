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
end
