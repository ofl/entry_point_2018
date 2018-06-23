class Types::QueryType < Types::BaseObject
  description 'The query root of this schema'

  field :user, Types::UserType, null: true do
    description 'Find a user by username'
    argument :username, String, required: true
  end

  field :current_user, Types::UserType, null: true do
    description 'Find current user'
  end

  def user(username:)
    User.find_by(username: username)
  end

  def current_user
    context[:current_user]
  end
end
