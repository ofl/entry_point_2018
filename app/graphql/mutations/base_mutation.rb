class Mutations::BaseMutation < GraphQL::Schema::RelayClassicMutation
  def convert_errors(errors)
    errors.map do |attribute, message|
      {
        message: message,
        path: ['attributes', attribute.to_s.camelize(:lower)]
      }
    end
  end

  # HACK: 以下query_typeとメソッドを共用したい

  def check_authorization_status
    raise_authorization_error unless authorized?
  end

  def raise_authorization_error
    raise GraphQL::ExecutionError, 'ログインが必要です'
  end

  def authorized?
    context[:current_user]&.persisted?
  end
end
