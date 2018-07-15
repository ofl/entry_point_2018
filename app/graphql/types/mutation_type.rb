class Types::MutationType < Types::BaseObject
  field :create_comment, mutation: Mutations::Comments::Create
  field :update_comment, mutation: Mutations::Comments::Update
end
