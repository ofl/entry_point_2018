class Mutations::Comments::Update < Mutations::BaseMutation
  graphql_name 'updateComment'
  description 'コメントの修正'

  null true

  argument :id, ID, description: 'コメントID', required: true
  argument :body, String, description: 'コメントの本文', required: true

  field :comment, Types::CommentType, null: true
  field :errors, [Types::UserError], null: false

  def resolve(id:, body:)
    # HACK: 認証状態の確認。メソッドごとにcheck_authorization_statusを書くのは冗長なので
    check_authorization_status

    comment = Comment.find(id)
    check_permission(comment)

    comment.update(body: body)

    {
      comment: comment,
      errors: convert_errors(comment.errors)
    }
  end
end
