class Types::UserType < Types::BaseObject
  description 'User'

  field :id, ID, null: false
  field :username, String, null: false
  field :email, String, null: true
end
