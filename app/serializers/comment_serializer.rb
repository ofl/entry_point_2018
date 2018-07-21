class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :username, :created_at, :updated_at
end
