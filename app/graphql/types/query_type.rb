class Types::QueryType < Types::BaseObject
  description 'The query root of this schema'

  field :user, resolver: Queries::Users::Show
  field :current_user, resolver: Queries::Users::Current

  field :post, resolver: Queries::Posts::Show
end
