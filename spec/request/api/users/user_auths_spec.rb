require 'rails_helper'

RSpec.describe 'user_auths', type: :request do
  include ApiRequestSpecHelper

  let(:user) { create :user }

  describe 'POST /api/users/user_auths' do
    subject { post api_users_user_auths_path, params: params.to_json, headers: headers }

    let(:valid_params) do
      { user_auth: { provider: 'email', uid: 'foobarbaz@example.com', user_password: user.password } }
    end
    let(:invalid_params) { { user_auth: { provider: 'email', uid: '', user_password: user.password } } }
    let(:invalid_password_params) do
      { user_auth: { provider: 'email', uid: 'foobarbaz@example.com', user_password: 'hoge' } }
    end

    context 'ログインしていない場合' do
      it '401エラーになること' do
        is_expected.to eq 401
      end
    end

    context 'ログインしている場合' do
      before { login }

      let(:user) { login_user }

      context '入力値がない場合' do
        it_behaves_like 'エンドポイントに必須のパラメータを渡さなかった場合', 'user_auth'
      end

      context '不正な入力値の場合' do
        let(:params) { invalid_params }

        it { is_expected.to eq 400 }
      end

      context 'パスワードが間違っている場合' do
        let(:params) { invalid_password_params }

        it { is_expected.to eq 400 }
      end

      context '正しい入力値の場合' do
        let(:params) { valid_params }

        it { is_expected.to eq 200 }

        it 'ユーザー認証が作成されること', autodoc: true do
          subject
          expect(json['message']).to eq 'Sent confirmation mail'
        end

        it 'ユーザー認証が増加すること' do
          expect { subject }.to change(UserAuth, :count).by(1)
        end
      end
    end
  end

  describe 'DELETE /api/users/user_auths/:provider' do
    subject { delete api_users_user_auth_path(provider: provider), params: params.to_json, headers: headers }

    let(:provider) { 'facebook' }
    let(:params) { { user_auth: { user_password: password } } }
    let(:password) { user.password }

    context 'ログインしていない場合' do
      it { is_expected.to eq 401 }
    end

    context 'ログインしている場合' do
      before { login }

      let(:user) { login_user }

      context '本人確認が存在しない場合' do
        it { is_expected.to eq 404 }
      end

      context '本人確認が存在する場合' do
        before { create :user_auth, user: user, provider: :facebook }

        context '不正な入力値の場合' do
          let(:password) { 'foobaabaz' }

          it '400エラーになること' do is_expected.to eq 400 end
          it '本人確認は減少しないこと' do expect { subject }.not_to change(UserAuth, :count) end
        end

        context '正しい入力値の場合' do
          it 'エラーが発生しないこと' do is_expected.to eq 200 end
          it '本人確認が減少すること' do expect { subject }.to change(UserAuth, :count).by(-1) end
        end
      end
    end
  end
end
