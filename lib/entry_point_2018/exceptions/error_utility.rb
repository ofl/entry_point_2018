module EntryPoint2018
  class ErrorUtility
    def self.log_and_notify(error)
      Rails.logger.error error.class
      Rails.logger.error error.message
      Rails.logger.error error.backtrace.join("\n")
      # Bugsnag.notify error
    end
  end
end
