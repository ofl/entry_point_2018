module OmniauthSpecHelper # rubocop:disable Metrics/ModuleLength
  def self.included(base)
    base.after(:each) { OmniAuth.config.mock_auth[:facebook] = nil }
  end

  def preset_mock(provider, uid, invalid: false)
    OmniAuth.config.mock_auth[provider] = if invalid
                                            :invalid_credentials
                                          else
                                            OmniAuth::AuthHash.new(send("#{provider}_hash", uid))
                                          end
  end

  def facebook_hash(uid) # rubocop:disable Metrics/MethodLength
    {
      provider: 'facebook',
      uid: uid,
      info: {
        email: 'joe@bloggs.com',
        name: 'Joe Bloggs',
        first_name: 'Joe',
        last_name: 'Bloggs',
        image: 'http://graph.facebook.com/1234567/picture?type=square',
        verified: true
      },
      credentials: {
        token: 'ABCDEF...', # OAuth 2.0 access_token, which you may wish to store
        expires_at: 1_321_747_205, # when the access token expires (it always will)
        expires: true # this will always be true
      },
      extra: {
        raw_info: {
          id: uid,
          name: 'Joe Bloggs',
          first_name: 'Joe',
          last_name: 'Bloggs',
          link: 'http://www.facebook.com/jbloggs',
          username: 'jbloggs',
          location: { id: '123456789', name: 'Palo Alto, California' },
          gender: 'male',
          email: 'joe@bloggs.com',
          timezone: -8,
          locale: 'en_US',
          verified: true,
          updated_time: '2011-11-11T06:21:03+0000'
        }
      }
    }
  end

  def twitter_hash(uid) # rubocop:disable Metrics/MethodLength
    {
      provider: 'twitter',
      uid: uid,
      info: {
        nickname: 'johnqpublic',
        name: 'John Q Public',
        location: 'Anytown, USA',
        image: 'http://si0.twimg.com/sticky/default_profile_images/default_profile_2_normal.png',
        description: 'a very normal guy.',
        urls: {
          Website: nil,
          Twitter: 'https://twitter.com/johnqpublic'
        }
      },
      credentials: {
        token: 'a1b2c3d4...', # The OAuth 2.0 access token
        secret: 'abcdef1234'
      },
      extra: {
        access_token: '', # An OAuth::AccessToken object
        raw_info: {
          name: 'John Q Public',
          listed_count: 0,
          profile_sidebar_border_color: '181A1E',
          url: nil,
          lang: 'en',
          statuses_count: 129,
          profile_image_url: 'http://si0.twimg.com/sticky/default_profile_images/default_profile_2_normal.png',
          profile_background_image_url_https: 'https://twimg0-a.akamaihd.net/profile_background_images/229171796/pattern_036.gif',
          location: 'Anytown, USA',
          time_zone: 'Chicago',
          follow_request_sent: false,
          id: 123_456,
          profile_background_tile: true,
          profile_sidebar_fill_color: '666666',
          followers_count: 1,
          default_profile_image: false,
          screen_name: '',
          following: false,
          utc_offset: -3600,
          verified: false,
          favourites_count: 0,
          profile_background_color: '1A1B1F',
          is_translator: false,
          friends_count: 1,
          notifications: false,
          geo_enabled: true,
          profile_background_image_url: 'http://twimg0-a.akamaihd.net/profile_background_images/229171796/pattern_036.gif',
          protected: false,
          description: 'a very normal guy.',
          profile_link_color: '2FC2EF',
          created_at: 'Thu Jul 4 00:00:00 +0000 2013',
          id_str: '123456',
          profile_image_url_https: 'https://si0.twimg.com/sticky/default_profile_images/default_profile_2_normal.png',
          default_profile: false,
          profile_use_background_image: false,
          entities: {
            description: {
              urls: []
            }
          },
          profile_text_color: '666666',
          contributors_enabled: false
        }
      }
    }
  end
end
