class AuthProviders::Twitter
  require 'twitter'

  def user_account(params) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    tw_account = client(params[:access_token], params[:access_secret]).verify_credentials
    {
      uid: tw_account.id,
      name: tw_account.name,
      nickname: tw_account.screen_name,
      email: tw_account.email,
      country: tw_account.status.try(:place).try(:country_code),
      url: tw_account.url,
      image_url: tw_account.profile_image_url,
      description: tw_account.description,
      city: tw_account.location
    }
  end

  def post_message(params, message)
    client(params[:access_token], params[:access_secret]).update(message)
  end

  private

  def client(access_token, access_secret)
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_API_KEY']
      config.consumer_secret = ENV['TWITTER_API_SECRET']
      config.access_token = access_token
      config.access_token_secret = access_secret
    end
  end
end
