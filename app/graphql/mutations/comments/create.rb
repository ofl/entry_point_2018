class Mutations::Comments::Create < Mutations::BaseMutation
  graphql_name 'createComment'
  description 'コメントの追加'

  null true

  field :comment, Types::CommentType, null: true
  field :errors, [Types::UserError], null: false

  argument :body, String, description: 'コメントの本文', required: true
  argument :post_id, ID, description: 'コメントを追加する投稿ID', required: true

  def resolve(body:, post_id:)
    # HACK: 認証状態の確認。メソッドごとにcheck_authorization_statusを書くのは冗長なので
    check_authorization_status

    comment = Comment.create(
      user: context[:current_user],
      body: body,
      post_id: post_id
    )

    {
      comment: comment,
      errors: convert_errors(comment.errors)
    }
  end
end
