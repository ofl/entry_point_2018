module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def resource_class
    User
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def user_avatar(user, size = :small)
    avatar_url = user.avatar ? user.avatar_url : '/images/default-avatar.png'
    image_size = size == :large ? '160x160' : '32x32'

    image_tag(avatar_url, size: image_size, alt: 'avatar')
  end
end
