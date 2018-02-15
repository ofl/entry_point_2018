require 'rails_helper'

RSpec.describe 'user_auths', type: :request do
  include ApiRequestSpecHelper

  let(:user) { create :user }

  describe 'POST /api/users/user_auths' do
    let(:valid_params) do
      { user_auth: { provider: 'email', uid: 'foobarbaz@example.com', user_password: user.password } }
    end
    let(:invalid_params) { { user_auth: { provider: 'email', uid: '', user_password: user.password } } }
    let(:invalid_password_params) do
      { user_auth: { provider: 'email', uid: 'foobarbaz@example.com', user_password: 'hoge' } }
    end

    subject { post api_users_user_auths_path, params: params.to_json, headers: headers }

    context 'not logged in' do
      it { is_expected.to eq 401 }
    end

    context 'logged in' do
      before { login }
      let(:user) { login_user }

      context 'no params' do
        it { is_expected.to eq 500 }

        it do
          subject
          expect(json['errors'][0]).to eq 'param is missing or the value is empty: user_auth'
        end
      end

      context 'invalid params' do
        let(:params) { invalid_params }

        it { is_expected.to eq 400 }
      end

      context 'invalid password params' do
        let(:params) { invalid_password_params }

        it { is_expected.to eq 400 }
      end

      context 'valid params' do
        let(:params) { valid_params }

        it do
          is_expected.to eq 200
          expect(json['message']).to eq 'Sent confirmation mail'
        end

        it { expect { subject }.to change(UserAuth, :count).by(1) }
      end
    end
  end

  describe 'DELETE /api/users/user_auths/:provider' do
    subject { delete api_users_user_auth_path(provider: provider), params: params, headers: headers }
    let(:provider) { 'facebook' }
    let(:params) { { user_auth: { user_password: password } } }
    let(:password) { user.password }

    context 'not logged in' do
      it { is_expected.to eq 401 }
    end

    context 'logged in' do
      before { login }
      let(:user) { login_user }

      context 'user_auth not exists' do
        it { is_expected.to eq 404 }
      end

      context 'user_auth exists' do
        before { create :user_auth, user: user, provider: :facebook }

        context 'invalid params' do
          let(:password) { 'foobaabaz' }

          it { is_expected.to eq 400 }
          it { expect { subject }.not_to change(UserAuth, :count) }
        end

        context 'valid params' do
          it { is_expected.to eq 200 }
          it { expect { subject }.to change(UserAuth, :count).by(-1) }
        end
      end
    end
  end
end
