require 'rails_helper'

RSpec.describe 'Users::Sessions', type: :request do
  let(:user) { create :user }

  describe 'GET /users/session/new' do
    subject { get new_user_session_path }

    context 'not logged in' do
      it { is_expected.to eq 200 }
    end

    context 'logged in' do
      before { sign_in user }

      it { is_expected.to redirect_to authenticated_root_path }
    end
  end

  describe 'POST /users/session' do
    subject { post user_session_path, params: params }
    let(:valid_params) { { user: { login: user.username, password: user.password } } }
    let(:valid_email_params) { { user: { login: user.username, password: user.password } } }
    let(:invalid_params) { { user: { login: user.username, password: 'a' } } }

    context 'logged in' do
      let(:params) { valid_params }
      it { is_expected.to redirect_to authenticated_root_path }
    end

    context 'not logged in' do
      context 'invalid params' do
        let(:params) { invalid_params }
        it { is_expected.to eq 200 }
      end

      context 'valid params' do
        let(:params) { valid_params }
        it { is_expected.to redirect_to authenticated_root_path }
      end

      context 'valid email params' do
        let(:params) { valid_email_params }
        it { is_expected.to redirect_to authenticated_root_path }
      end
    end
  end
end
