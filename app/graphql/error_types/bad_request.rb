class ErrorTypes::BadRequest < ErrorTypes
  ERROR_CODE = 'BAD_USER_INPUT'.freeze

  def initialize(error, error_code = ERROR_CODE)
    super
  end

  def message
    I18n.t('graphql.errors.messages.bad_request')
  end
end
