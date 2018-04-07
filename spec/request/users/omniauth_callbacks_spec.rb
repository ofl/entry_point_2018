require 'rails_helper'

RSpec.shared_examples 'ソーシャルログインの使用' do
  subject { get "/users/auth/#{provider}/callback" }

  context '本人確認が失敗した場合' do
    before do
      allow($stdout).to receive(:write) # Suppress console output
      preset_mock(provider, nil, invalid: true)
    end

    it 'ログイン画面にリダイレクトされること' do is_expected.to redirect_to new_user_session_path end
  end

  context '本人確認が成功した場合' do
    before do
      preset_mock(provider, uid)
      Rails.application.env_config['omniauth.test_params'] = callback_params
    end

    context 'ログインの場合' do
      let(:callback_params) { {} }

      context 'ユーザーが存在しない場合' do
        let(:uid) { nil }

        it 'ログイン画面にリダイレクトされること' do
          is_expected.to redirect_to new_user_session_path
          expect(flash[:alert]).to eq(
            I18n.t('users.omniauth_callbacks.failure', provider: provider.capitalize)
          )
        end
      end

      context 'ユーザーが存在する場合' do
        let!(:user_auth) { create :user_auth, user: user, provider: provider, confirmed_at: confirmed_at }
        let(:uid) { user_auth.uid }

        context '本人確認が認証されていない場合' do
          let(:confirmed_at) { nil }

          it 'マイページにリダイレクトされること' do is_expected.to eq 302 end
        end

        context '本人確認が認証済みの場合' do
          let(:confirmed_at) { 1.day.ago }

          it 'マイページにリダイレクトされること' do
            is_expected.to redirect_to authenticated_root_path
            expect(flash[:notice]).to eq(
              I18n.t('devise.omniauth_callbacks.success', provider: provider.capitalize)
            )
          end
        end
      end
    end

    context '本人確認の追加の場合' do
      let(:callback_params) { { 'confirmation_token' => confirmation_token } }
      let!(:user_auth) do
        create :user_auth, user: user, provider: provider, confirmation_token: 'abc',
                           confirmation_sent_at: confirmation_sent_at
      end
      let(:uid) { user_auth.uid }
      let(:confirmation_token) { user_auth.confirmation_token }
      let(:confirmation_sent_at) { 1.minute.ago }

      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトされること' do is_expected.to eq 302 end
      end

      context 'ログインしている場合' do
        before { sign_in user }

        let(:user) { create :user, :confirmed }

        context '確認トークンがマッチしない場合' do
          let!(:another_user) { create :user }
          let!(:another_user_auth) do
            create :user_auth, user: another_user, provider: provider, confirmation_token: 'xyz'
          end
          let(:confirmation_token) { another_user_auth.confirmation_token }

          it 'マイページにリダイレクトされること' do is_expected.to eq 302 end
        end

        context '確認トークンがマッチした場合' do
          context '本人確認が時間切れの場合' do
            let(:confirmation_sent_at) { 3.days.ago }

            it 'マイページにリダイレクトされること' do
              is_expected.to redirect_to authenticated_root_path
            end

            it '「時間切れ」が表示されること' do
              subject
              expect(flash[:alert]).to eq(
                I18n.t('users.omniauth_callbacks.confirmation_period_expired')
              )
            end
          end

          context '本人確認が時間切れでない場合' do
            it 'マイページにリダイレクトされること' do
              is_expected.to redirect_to authenticated_root_path
            end
            it '「本人確認の成功」が表示されること' do
              subject
              expect(flash[:notice]).to eq(
                I18n.t('devise.omniauth_callbacks.success', provider: provider.capitalize)
              )
            end
          end
        end
      end
    end

    context 'パスワード変更の場合' do
      let(:callback_params) { { 'reset_password' => true } }
      let!(:user_auth) { create :user_auth, user: user, provider: provider, confirmed_at: confirmed_at }
      let(:uid) { user_auth.uid }
      let(:user) { create :user }

      before do
        allow_any_instance_of(User).to receive(:raw_reset_password_token).and_return('foobarbaz')
      end

      context '認証された本人確認が存在しない場合' do
        let(:confirmed_at) { nil }

        it '403エラーになること' do is_expected.to eq 403 end
      end

      context '認証された本人確認が存在する場合' do
        let(:confirmed_at) { 1.day.ago }

        it 'パスワード変更画面にリダイレクトされること' do
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
    it_behaves_like 'ソーシャルログインの使用' do
      let(:provider) { provider }
    end
  end
end
