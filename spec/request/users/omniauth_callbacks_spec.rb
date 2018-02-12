require 'rails_helper'

RSpec.shared_examples 'use social user_auth' do
  subject { get "/users/auth/#{provider}/callback" }

  context 'user_auth failed' do
    before do
      allow($stdout).to receive(:write) # Suppress console output
      preset_mock(provider, nil, invalid: true)
    end

    it { is_expected.to redirect_to new_user_session_path }
  end

  context 'user_auth success' do
    before do
      preset_mock(provider, uid)
      Rails.application.env_config['omniauth.test_params'] = callback_params
    end

    context 'sign in' do
      let(:callback_params) { {} }

      context 'user not exist' do
        let(:uid) { nil }
        it do
          is_expected.to redirect_to new_user_session_path
          expect(flash[:alert]).to eq(
            I18n.t('users.omniauth_callbacks.failure', provider: provider.capitalize)
          )
        end
      end

      context 'user exists' do
        let!(:user_auth) { create :user_auth, user: user, provider: provider, confirmed_at: confirmed_at }
        let(:uid) { user_auth.uid }

        context 'user_auth not confirmed' do
          let(:confirmed_at) { nil }

          it { is_expected.to eq 302 }
        end

        context 'user_auth not confirmed' do
          let(:confirmed_at) { 1.day.ago }

          it do
            is_expected.to redirect_to authenticated_root_path
            expect(flash[:notice]).to eq(
              I18n.t('devise.omniauth_callbacks.success', provider: provider.capitalize)
            )
          end
        end
      end
    end

    context 'connect' do
      let(:callback_params) { { 'confirmation_token' => confirmation_token } }
      let!(:user_auth) do
        create :user_auth, user: user, provider: provider, confirmation_token: 'abc',
                           confirmation_sent_at: confirmation_sent_at
      end
      let(:uid) { user_auth.uid }
      let(:confirmation_token) { user_auth.confirmation_token }
      let(:confirmation_sent_at) { 1.minute.ago }

      context 'not logged in' do
        it { is_expected.to eq 302 }
      end

      context 'logged in' do
        before { sign_in user }

        let(:user) { create :user, :confirmed }

        context 'user_auth user not match' do
          let!(:another_user) { create :user }
          let!(:another_user_auth) do
            create :user_auth, user: another_user, provider: provider, confirmation_token: 'xyz'
          end
          let(:confirmation_token) { another_user_auth.confirmation_token }

          it { is_expected.to eq 302 }
        end

        context 'user_auth user confirmation_token match' do
          context 'confirmation_token time out' do
            let(:confirmation_sent_at) { 3.days.ago }

            it do
              is_expected.to redirect_to root_path
              expect(flash[:alert]).to eq(
                I18n.t('users.omniauth_callbacks.confirmation_period_expired')
              )
            end
          end

          context 'confirmation_token not time out' do
            it do
              is_expected.to redirect_to root_path
              expect(flash[:notice]).to eq(
                I18n.t('devise.omniauth_callbacks.success', provider: provider.capitalize)
              )
            end
          end
        end
      end
    end

    context 'reset_password' do
      let(:callback_params) { { 'reset_password' => true } }
      let!(:user_auth) { create :user_auth, user: user, provider: provider, confirmed_at: confirmed_at }
      let(:uid) { user_auth.uid }
      let(:user) { create :user }

      before do
        allow_any_instance_of(User).to receive(:raw_reset_password_token).and_return('foobarbaz')
      end

      context 'confirmed user_auth not exists' do
        let(:confirmed_at) { nil }
        it { is_expected.to eq 403 }
      end

      context 'confirmed user_auth exists' do
        let(:confirmed_at) { 1.day.ago }

        it do
          is_expected.to redirect_to edit_user_password_path(reset_password_token: 'foobarbaz')
        end
      end
    end
  end
end

RSpec.describe 'Users::OmniauthCallbacks', type: :request do
  include OmniauthSpecHelper

  let(:user) { create :user }

  %i[facebook twitter].each do |provider|
    it_behaves_like 'use social user_auth' do
      let(:provider) { provider }
    end
  end
end
