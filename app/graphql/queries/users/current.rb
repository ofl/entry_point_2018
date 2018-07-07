class Queries::Users::Current < GraphQL::Schema::Resolver
  graphql_name 'CurrentUser'

  type Types::UserType, null: false

  def resolve
    context[:current_user]
  end
end
