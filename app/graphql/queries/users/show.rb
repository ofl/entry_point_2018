class Queries::Users::Show < GraphQL::Schema::Resolver
  graphql_name 'User'
  description '指定したユーザー名のユーザーを取得する'

  type Types::UserType, null: true

  argument :username, String, required: true

  def resolve(username:)
    User.find_by(username: username)
  end
end
