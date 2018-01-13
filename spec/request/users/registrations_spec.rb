require 'rails_helper'

RSpec.describe 'Users::Registrations', type: :request do
  let(:user) { create :user }

  describe 'GET /users/registration/new' do
    subject { get new_user_registration_path }

    context 'not logged in' do
      it { is_expected.to eq 200 }
    end

    context 'logged in' do
      before { sign_in user }

      it { is_expected.to redirect_to authenticated_root_path }
    end
  end

  describe 'POST /users/registration' do
    subject { post user_registration_path, params: params }
    let(:valid_params) { { user: { username: 'foo', email: 'foo@example.com', password: 'password' } } }
    let(:invalid_params) { { user: { username: 'foo', email: user.email, password: 'a' } } }

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
        it { is_expected.to redirect_to authenticated_root_path }
      end
    end
  end
end
