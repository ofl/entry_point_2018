class RegistrantSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :authentication_token, :created_at, :updated_at,
             :confirmed_by_email, :confirmed_by_twitter, :confirmed_by_facebook

  def confirmed_by_email
    object.confirmed_by?(:email)
  end

  def confirmed_by_twitter
    object.confirmed_by?(:twitter)
  end

  def confirmed_by_facebook
    object.confirmed_by?(:facebook)
  end
end
