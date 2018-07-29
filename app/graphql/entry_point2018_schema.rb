class EntryPoint2018Schema < GraphQL::Schema
  # GraphQLではエラーは全てレスキューしてstatusを200で返すようにする
  include EntryPoint2018::Exceptions

  rescue_from(StandardError) do |error|
    EntryPoint2018::ErrorUtility.log_and_notify(error)

    converted_error = EntryPoint2018::Exceptions.for_api(error).new(error.message)

    raise GraphQL::ExecutionError.new(converted_error.message, extensions: converted_error.to_graphql_extensions)
  end

  max_complexity 400
  max_depth 10
  mutation Types::MutationType
  query Types::QueryType
end
