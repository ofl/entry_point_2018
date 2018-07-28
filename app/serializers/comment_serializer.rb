class CommentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :body, :username, :created_at, :updated_at
end
