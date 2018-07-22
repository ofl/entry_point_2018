class Mutations::BaseMutation < GraphQL::Schema::RelayClassicMutation
  def check_authorization_and_excute(check_authorization: true)
    check_authorization_status if check_authorization

    yield
  rescue ActiveRecord::RecordInvalid => error
    EntryPoint2018::ErrorUtility.log_and_notify(error)
    converted_error = EntryPoint2018::Exceptions::BadRequest.new(error.message)

    convert_to_bad_request_errors(converted_error, error.record.errors)
  end

  def convert_to_bad_request_errors(error, errors)
    errors.map do |attribute, message|
      extensions = error.to_graphql_extensions.merge(path: ['attributes', attribute.to_s.camelize(:lower)])

      context.add_error(GraphQL::ExecutionError.new(message, extensions: extensions))
    end
    nil
  end

  # HACK: 以下query_typeとメソッドを共用したい

  def check_authorization_status
    raise EntryPoint2018Schema::Unauthorized unless authorized?
  end

  def check_permission(target, attribute = 'id')
    return if target.user == context[:current_user]

    # モデル名を翻訳する
    t_model = I18n.t('activerecord.models.' + target.class.name.underscore)
    t_value = target.__send__(attribute)
    message = I18n.t('graphql.errors.messages.permission_denied', klass: t_model, attribute: attribute, value: t_value)

    raise EntryPoint2018Schema::Forbidden, message
  end

  def authorized?
    context[:current_user]&.persisted?
  end
end
