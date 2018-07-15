class ErrorTypes::Forbidden < ErrorTypes
  ERROR_CODE = 'FORBIDDEN'.freeze

  def message
    @error.message || I18n.t('graphql.errors.messages.forbidden')
  end
end
