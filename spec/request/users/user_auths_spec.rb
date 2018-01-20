require 'rails_helper'

RSpec.describe 'Users::UserAuths', type: :request do
  let(:user) { create :user }

  describe 'GET /users/user_auths' do
    subject { get users_user_auth_path(provider: 'facebook'), params: params }
    let(:valid_params) { { confirmation_token: 'foobaabaz' } }
    let(:invalid_params) { { confirmation_token: 'abc' } }
    let!(:user) { create :user }
    let!(:unconfirmed_user_auth) do
      create :user_auth, user: user, provider: :facebook, confirmation_token: 'foobaabaz', confirmation_sent_at: sent_at
    end
    let(:sent_at) { 1.minute.ago }

    let(:user) { create :user, :confirmed }

    context 'invalid params' do
      let(:params) { invalid_params }
      it { expect { subject }.to raise_error ActiveRecord::RecordNotFound }
    end

    context 'valid params' do
      let(:params) { valid_params }

      context 'confirmation expired' do
        let(:sent_at) { 1.day.ago }

        it do
          is_expected.to eq 302
          expect(flash[:alert]).to eq(I18n.t('users.user_auths.confirmation_period_expired'))
        end
      end

      context 'confirmation expired' do
        it do
          is_expected.to eq 302
          expect(flash[:notice]).to eq(
            I18n.t('users.user_auths.confirmed')
          )
        end
      end
    end
  end

  describe 'GET /users/user_auths/new' do
    subject { get new_users_user_auth_path }

    context 'not logged in' do
      it { is_expected.to redirect_to new_user_session_path }
    end

    context 'logged in' do
      before { sign_in user }

      let(:user) { create :user, :confirmed }

      it { is_expected.to eq 200 }
    end
  end

  describe 'POST /users/user_auths' do
    subject { post users_user_auths_path, params: params }
    let(:valid_params) do
      { user_auth: { provider: 'email', uid: 'foobarbaz@example.com', user: { password: 'password' } } }
    end
    let(:invalid_params) { { user_auth: { provider: 'email', uid: '', user: { password: 'password' } } } }
    let(:invalid_password_params) { { user_auth: { provider: 'email', uid: '', user: { password: 'hoge' } } } }

    context 'not logged in' do
      let(:params) { valid_params }
      it { is_expected.to redirect_to new_user_session_path }
    end

    context 'logged in' do
      before { sign_in user }

      let(:user) { create :user, :confirmed }

      context 'invalid params' do
        let(:params) { invalid_params }

        it { is_expected.to eq 200 }
      end

      context 'invalid password params' do
        let(:params) { invalid_password_params }

        it { is_expected.to eq 200 }
      end

      context 'valid params' do
        let(:params) { valid_params }

        it { is_expected.to eq 302 }
        it do
          expect { subject }
            .to change { UserAuth.count }
            .by(1)
            .and change { ActionMailer::Base.deliveries.count }
            .by(1)
        end
      end
    end
  end

  describe 'DELETE /users/user_auths' do
    subject { delete users_user_auth_path(provider: provider) }
    let(:provider) { 'facebook' }

    context 'not logged in' do
      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'logged in' do
      before { sign_in user }

      let(:user) { create :user, :confirmed }

      context 'user_auth not exists' do
        it do
          is_expected.to redirect_to(authenticated_root_path)
          expect(flash[:notice]).to be_nil
        end
      end

      context 'user_auth exists' do
        before { create :user_auth, user: user, provider: :facebook }
        it do
          is_expected.to redirect_to(authenticated_root_path)
          expect(flash[:notice]).to eq(
            I18n.t('users.user_auths.delete_user_auth', provider: provider.capitalize)
          )
        end
      end
    end
  end
end
