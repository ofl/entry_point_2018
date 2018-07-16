class ErrorTypes::NotAuthorized < ErrorTypes
  ERROR_CODE = 'NOT_AUTHORIZED'.freeze

  def initialize(error, error_code = ERROR_CODE)
    super
  end

  def message
    I18n.t('graphql.errors.messages.not_authorized')
  end
end
