class AuthProviders::Facebook
  require 'koala'

  def user_account(params) # rubocop:disable Metrics/MethodLength
    fb_profile = client(params[:access_token])
                 .get_object('me', fields: 'name,email,birthday,gender,website,about,location{location}')
    location = fb_profile['location'] || {}
    {
      uid: fb_profile['id'],
      name: fb_profile['name'],
      email: fb_profile['email'],
      url: fb_profile['website'],
      description: fb_profile['about'],
      country: location['country_code'],
      city: location['city'],
      birthday: birthday(fb_profile['birthday'])
    }
  end

  def post_message(params, message)
    client(params).put_connections('me', 'feed', message: message)
  end

  private

  def client(access_token)
    @client ||= Koala::Facebook::API.new(access_token)
  end

  def birthday(str)
    return nil if str.blank?

    Date.strptime(str, '%m/%d/%Y')
  rescue ArgumentError
    nil
  end
end
