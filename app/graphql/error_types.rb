class ErrorTypes
  ERROR_CODE = 'UNKNOWN'.freeze

  def initialize(error, error_code = slef.class::ERROR_CODE)
    @error = error
    @error_code = error_code
  end

  def message
    NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  def extensions
    {
      code: @error_code,
      exception: exception
    }
  end

  def logs
    ["[ERROR]#{@error}"]
  end

  private

  def exception
    { stacktrace: [] }
  end
end
