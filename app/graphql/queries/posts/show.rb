class Queries::Posts::Show < GraphQL::Schema::Resolver
  graphql_name 'Post'
  description '指定したIDの投稿を取得する'

  type Types::PostType, null: true

  argument :id, ID, required: true

  def resolve(id:)
    Post.find_by(id: id)
  end
end
