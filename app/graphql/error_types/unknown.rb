class ErrorTypes::Unknown < ErrorTypes
  ERROR_CODE = 'UNKNOWN'.freeze

  def initialize(error, error_code = ERROR_CODE)
    super
  end

  def message
    I18n.t('graphql.errors.messages.not_authorized')
  end

  def log
    ["[ERROR]#{@error}"] + error.backtrace
  end

  def exception
    stacktrace = Rails.env.development? ? @error.backtrace : []
    {
      stacktrace: stacktrace
    }
  end
end
