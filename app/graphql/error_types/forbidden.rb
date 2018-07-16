class ErrorTypes::Forbidden < ErrorTypes
  ERROR_CODE = 'FORBIDDEN'.freeze

  def initialize(error, error_code = ERROR_CODE)
    super
  end

  def message
    @error.message || I18n.t('graphql.errors.messages.forbidden')
  end
end
