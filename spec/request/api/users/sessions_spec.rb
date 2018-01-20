require 'rails_helper'

RSpec.describe 'sessions', type: :request do
  include ApiRequestSpecHelper
  include AuthTokenSpecHelper

  let(:session_structure) do
    { 'authentication_token' => a_kind_of(String) }
  end
  let(:valid_params) { { user: { username: 'foo', password: 'password' } } }

  let(:valid_tw_params) do
    {
      user_auth: {
        provider: 'twitter',
        uid: test_tw_user[:uid],
        access_token: test_tw_user[:access_token],
        access_secret: test_tw_user[:access_secret]
      }
    }
  end
  let(:valid_fb_params) do
    {
      user_auth: {
        provider: 'facebook',
        uid: test_fb_user[:uid],
        access_token: test_fb_user[:access_token]
      }
    }
  end

  describe 'POST /api/users/sessions' do
    subject { post '/api/users/sessions', params: params.to_json, headers: headers }

    context 'no params' do
      it { is_expected.to eq 500 }

      it do
        subject
        expect(json['errors'][0]).to eq 'param is missing or the value is empty: user_auth'
      end
    end

    context 'valid params' do
      let(:params) { valid_params }

      before do
        create(:user, username: 'foo', password: 'password')
      end

      it do
        subject
        is_expected.to eq 200
        expect(json).to match(session_structure)
      end
    end

    context 'valid twitter params' do
      let(:params) { valid_tw_params }

      before do
        user = create(:user)
        create(:user_auth, provider: 'twitter', uid: test_tw_user[:uid], user: user)
      end

      it do
        VCR.use_cassette 'twitter_valid_credential' do
          subject
          is_expected.to eq 200
          expect(json).to match(session_structure)
        end
      end
    end

    # context 'valid facebook params' do
    #   let(:params) { valid_fb_params }
    #
    #   before do
    #     user = create(:user)
    #     create(:user_auth, provider: 'facebook', uid: test_fb_user[:uid], user: user)
    #   end
    #
    #   it do
    #     VCR.use_cassette 'facebook_valid_credential' do
    #       subject
    #       is_expected.to eq 200
    #       expect(json).to match(session_structure)
    #     end
    #   end
    # end

    context 'user not found' do
      let(:params) { valid_params }

      it { is_expected.to eq 404 }
    end
  end

  describe 'DELETE /api/users/sessions' do
    subject { delete '/api/users/sessions', params: params.to_json, headers: headers }

    context 'not logged in' do
      it { is_expected.to eq 401 }
    end

    context 'logged in' do
      before { login }

      it do
        before_authentication_token = login_user.authentication_token

        subject

        is_expected.to eq 200
        expect(login_user.reload.authentication_token).not_to eq before_authentication_token
      end
    end
  end
end
