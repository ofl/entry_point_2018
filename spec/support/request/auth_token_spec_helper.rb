require 'active_support/concern'

module AuthTokenSpecHelper
  extend ActiveSupport::Concern

  included do
    let(:test_fb_user) do
      { uid: Settings.facebook.test_uid, access_token: Settings.facebook.test_access_token }
    end
    let(:test_tw_user) do
      {
        uid: Settings.twitter.test_uid,
        access_token: Settings.twitter.test_access_token,
        access_secret: Settings.twitter.test_access_secret
      }
    end
  end
end
