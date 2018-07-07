class Queries::Posts::Index < GraphQL::Schema::Resolver
  graphql_name 'Post Index'
  description '投稿の一覧'

  type [Types::PostType], null: false

  def resolve
    Post.includes(:user).all
  end
end
