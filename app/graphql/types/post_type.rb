class Types::PostType < Types::BaseObject
  description '投稿'

  field :id, ID, null: false, description: '投稿ID'
  field :title, String, null: false, description: 'タイトル'
  field :body, String, null: false,  description: '本文'
  field :user, Types::UserType, null: false, description: '投稿者'
  field :comments, [Types::CommentType], null: false, description: 'コメント'
end
