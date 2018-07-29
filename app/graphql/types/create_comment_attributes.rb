class Types::CreateCommentAttributes < Types::BaseInputObject
  description 'Attributes for creating a post comment'
  argument :post_id, ID, 'ID for the post', required: true
  argument :body, String, 'Body for the post comment', required: true
end
