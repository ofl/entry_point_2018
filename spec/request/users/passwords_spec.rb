require 'rails_helper'

RSpec.describe 'Users::Passwords', type: :request do
  let(:user) { create :user }

  describe 'GET /users/password/new' do
    subject { get new_user_password_path }

    context 'not logged in' do
      it { is_expected.to eq 200 }
    end

    context 'logged in' do
      before { sign_in user }

      it { is_expected.to redirect_to authenticated_root_path }
    end
  end

  describe 'POST /users/password' do
    subject { post user_password_path, params: params }
    let(:valid_params) { { user: { email: user.email } } }
    let(:invalid_params) { { user: { email: 'foo@example.com' } } }

    context 'logged in' do
      let(:params) { valid_params }
      before { sign_in user }

      it { is_expected.to redirect_to authenticated_root_path }
    end

    context 'not logged in' do
      context 'invalid params' do
        let(:params) { invalid_params }

        it { is_expected.to eq 200 }
      end

      context 'valid params' do
        let(:params) { valid_params }

        it { is_expected.to redirect_to new_user_session_path }
        it do
          expect { subject }.to(change { ActionMailer::Base.deliveries.count })
        end
      end
    end
  end
end
