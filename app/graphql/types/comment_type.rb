class Types::CommentType < Types::BaseObject
  description 'コメント'

  field :id, ID, null: false, description: 'コメントID'
  field :body, String, null: false, description: '本文'
  field :user, Types::UserType, null: false, description: '投稿者'
  field :post, Types::PostType, null: false, description: '投稿'
end
