class Mutations::Comments::Create < Mutations::BaseMutation
  graphql_name 'createComment'
  description 'コメントの追加'

  null true

  argument :attributes, Types::CreateCommentAttributes, required: true

  field :comment, Types::CommentType, null: true

  def resolve(attributes:)
    check_authorization_and_excute do
      comment = context[:current_user].comments.create!(attributes.to_h)
      { comment: comment }
    end
  end
end
