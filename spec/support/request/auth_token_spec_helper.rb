require 'active_support/concern'

module AuthTokenSpecHelper
  extend ActiveSupport::Concern

  included do
    let(:test_fb_user) do
      {
        uid: ENV['FACEBOOK_TEST_UID'],
        access_token: ENV['FACEBOOK_TEST_ACCESS_TOKEN']
      }
    end

    let(:test_tw_user) do
      {
        uid: ENV['TWITTER_TEST_UID'],
        access_token: ENV['TWITTER_TEST_ACCESS_TOKEN'],
        access_secret: ENV['TWITTER_TEST_ACCESS_SECRET']
      }
    end
  end
end
