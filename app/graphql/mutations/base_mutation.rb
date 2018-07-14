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
    raise GraphQL::NotAuthorized, 'ログインが必要です' unless authorized?
  end

  def authorized?
    context[:current_user]&.persisted?
  end
end
