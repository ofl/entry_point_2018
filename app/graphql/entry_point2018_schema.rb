GraphQL::NotAuthorized = Class.new(GraphQL::ExecutionError)
GraphQL::NotFound = Class.new(GraphQL::ExecutionError)
GraphQL::Forbidden = Class.new(GraphQL::ExecutionError)
GraphQL::BadRequest = Class.new(GraphQL::ExecutionError)

class EntryPoint2018Schema < GraphQL::Schema
  rescue_from(Exception) do |error|
    Rails.logger.error "[ERROR]#{error}"

    case error
    when ActiveRecord::RecordInvalid
      GraphQL::BadRequest.new I18n.t('graphql.errors.messages.bad_request')
    when ActiveRecord::RecordNotFound
      GraphQL::NotFound.new translate_record_not_found(error.message)
    else
      Rails.logger.error error.backtrace.join("\n")
      GraphQL::ExecutionError.new '原因不明のエラーが発生しました'
    end
  end

  mutation(Types::MutationType)
  query(Types::QueryType)

  # https://qiita.com/arakaji/items/7a7c262f35b17195d3d7
  def self.translate_record_not_found(error_msg)
    match = error_msg.match(/^Couldn't find ([\S].*) with '([\S]*)'=([\S].*)$/)

    # モデル名を翻訳する
    t_model = I18n.t('activerecord.models.' + match[1].underscore)
    # 属性名を翻訳する
    t_attr = I18n.t('activerecord.attributes.' + match[1].underscore + '.' + match[2])

    I18n.t('graphql.errors.messages.not_found', klass: t_model, attribute: t_attr, value: match[3])
  end
end
