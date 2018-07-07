class Types::MutationType < Types::BaseObject
  field :create_comment, mutation: Mutations::Comments::Create
end
