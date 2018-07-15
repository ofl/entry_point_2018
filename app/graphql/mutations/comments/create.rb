class Mutations::Comments::Create < Mutations::BaseMutation
  graphql_name 'createComment'
  description 'コメントの追加'

  null true

  argument :body, String, description: 'コメントの本文', required: true
  argument :post_id, ID, description: 'コメントを追加する投稿ID', required: true

  field :comment, Types::CommentType, null: true

  def resolve(body:, post_id:)
    # HACK: 認証状態の確認。メソッドごとにcheck_authorization_statusを書くのは冗長なので
    check_authorization_status

    post = Post.find_by(id: post_id)
    { comment: context[:current_user].comments.create!(post: post, body: body) }
  rescue ActiveRecord::RecordInvalid => e
    error_type = ErrorTypes::BadRequest.new(e)
    Rails.logger.error error_type.logs.join("\n")

    convert_to_bad_request_errors(error_type, e.record.errors)
  end
end
