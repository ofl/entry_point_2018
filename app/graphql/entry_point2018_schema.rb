class EntryPoint2018Schema < GraphQL::Schema
  NotAuthorized = Class.new(StandardError)
  Forbidden = Class.new(StandardError)
  BadRequest = Class.new(StandardError)

  rescue_from(Exception) do |error|
    error_type = error_type(error)
    Rails.logger.error error_type.logs.join("\n")

    raise GraphQL::ExecutionError.new(error_type.message, extensions: error_type.extensions)
  end

  max_complexity 400
  max_depth 10
  mutation Types::MutationType
  query Types::QueryType

  def self.error_type(error)
    case error
    when Forbidden
      ErrorTypes::Forbidden.new(error)
    when NotAuthorized
      ErrorTypes::NotAuthorized.new(error)
    when ActiveRecord::RecordNotFound
      ErrorTypes::NotFound.new(error)
    else
      ErrorTypes::Unknown.new(error)
    end
  end
end
