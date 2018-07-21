class ErrorTypes::Unauthorized < ErrorTypes
  ERROR_CODE = 'UNAUTHORIZED'.freeze

  def initialize(error, error_code = ERROR_CODE)
    super
  end

  def message
    I18n.t('graphql.errors.messages.unauthorized')
  end
end
