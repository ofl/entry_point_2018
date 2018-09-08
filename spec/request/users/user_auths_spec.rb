require 'rails_helper'

RSpec.describe '本人確認について', type: :request do
  let!(:user) { create :user, :confirmed, password: 'password' }

  describe 'GET /users/user_auths' do
    subject { get users_user_auth_path(provider: 'facebook'), params: params }

    let(:valid_params) { { confirmation_token: 'foobaabaz' } }
    let(:invalid_params) { { confirmation_token: 'abc' } }
    let(:params) { valid_params }
    let(:sent_at) { 1.minute.ago }

    before do
      create :user_auth, user: user, provider: :facebook, confirmation_token: 'foobaabaz', confirmation_sent_at: sent_at
    end

    context '不正な入力値の場合' do
      let(:params) { invalid_params }

      it '404エラーになること' do
        is_expected.to eq 404
      end
    end

    context '正しい入力値の場合' do
      context '認証期限が切れている場合' do
        let(:sent_at) { 1.day.ago }

        it { is_expected.to eq 302 }

        it '「期限切れです。もう一度手続きをしてください」が表示されること' do
          subject
          expect(flash[:alert]).to eq I18n.t('users.user_auths.confirmation_period_expired')
        end
      end

      context '認証期限内の場合' do
        it { is_expected.to eq 302 }

        it '「メールアドレスの確認が完了しました」が表示されること' do
          subject
          expect(flash[:notice]).to eq I18n.t('users.user_auths.confirmed')
        end
      end
    end
  end

  describe 'GET /users/user_auths/new' do
    subject { get new_users_user_auth_path }

    it_behaves_like 'ログインが必要なページへのアクセス'

    context 'ログインしている場合' do
      before { sign_in user }

      it '編集画面が表示されること' do is_expected.to eq 200 end
    end
  end

  describe 'POST /users/user_auths' do
    subject { post users_user_auths_path, params: params }

    let(:valid_params) do
      { user_auth: { provider: 'email', uid: 'foobarbaz@example.com', user_password: 'password' } }
    end
    let(:invalid_params) { { user_auth: { provider: 'email', uid: '', user_password: 'password' } } }
    let(:params) { valid_params }
    let(:invalid_password_params) { { user_auth: { provider: 'email', uid: '', user_password: 'hoge' } } }

    it_behaves_like 'ログインが必要なページへのアクセス'

    context 'ログインしている場合' do
      before { sign_in user }

      context '不正な入力値の場合' do
        let(:params) { invalid_params }

        it '編集画面が表示されること' do is_expected.to eq 200 end
      end

      context '不正なパスワードの場合' do
        let(:params) { invalid_password_params }

        it '編集画面が表示されること' do is_expected.to eq 200 end
      end

      context '正しい入力値の場合' do
        it 'マイページにリダイレクトされること' do is_expected.to eq 302 end
        it '本人確認が増加すること' do
          expect { subject }
            .to change(UserAuth, :count)
            .by(1)
            .and change { ActionMailer::Base.deliveries.count }
            .by(1)
        end
      end
    end
  end

  describe 'GET /users/user_auths/:provider/edit' do
    subject { get edit_users_user_auth_path(provider: provider) }

    let(:provider) { 'facebook' }

    it_behaves_like 'ログインが必要なページへのアクセス'

    context 'ログインしている場合' do
      before { sign_in user }

      context '本人確認が存在しない場合' do
        it '404エラーになること' do
          is_expected.to eq 404
        end
      end

      context '本人確認が存在する場合' do
        before { create :user_auth, user: user, provider: :facebook }

        it '編集画面が表示されること' do is_expected.to eq 200 end
      end
    end
  end

  describe 'DELETE /users/user_auths/:provider' do
    subject { delete users_user_auth_path(provider: provider), params: { user_auth: { user_password: password } } }

    let(:provider) { 'facebook' }
    let(:password) { 'password' }

    it_behaves_like 'ログインが必要なページへのアクセス'

    context 'ログインしている場合' do
      before { sign_in user }

      context '本人確認が存在しない場合' do
        it '404エラーになること' do
          is_expected.to eq 404
        end
      end

      context '本人確認が存在する場合' do
        before { create :user_auth, user: user, provider: :facebook }

        context '不正な入力値の場合' do
          let(:password) { 'fonnbarbaz' }

          it '編集画面が表示されること' do is_expected.to eq 200 end
          it '本人確認が減少しないこと' do
            expect { subject }.not_to change(UserAuth, :count)
          end
        end

        context '正しい入力値の場合' do
          it { is_expected.to redirect_to(authenticated_root_path) }

          it 'マイページにリダイレクトされること' do
            subject
            expect(flash[:notice]).to eq(
              I18n.t('users.user_auths.delete_user_auth', provider: provider.capitalize)
            )
          end

          it '本人確認が減少すること' do
            expect { subject }.to change(UserAuth, :count).by(-1)
          end
        end
      end
    end
  end
end
