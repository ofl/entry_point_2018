require 'rails_helper'

RSpec.describe 'Users::Sessions', type: :request do
  let!(:user) { create :user }

  describe 'GET /users/session/new' do
    subject { get new_user_session_path }

    context 'ログインしていない場合' do
      it 'ログイン画面が表示されること' do is_expected.to eq 200 end
    end

    context 'ログインしている場合' do
      before { sign_in user }

      it 'マイページにリダイレクトされること' do is_expected.to redirect_to authenticated_root_path end
    end
  end

  describe 'POST /users/session' do
    subject { post user_session_path, params: params }

    let(:valid_params) { { user: { login: user.username, password: user.password } } }
    let(:valid_email_params) { { user: { login: user.email, password: user.password } } }
    let(:invalid_params) { { user: { login: user.username, password: 'a' } } }

    context 'ログインしている場合' do
      before { sign_in user }

      let(:params) { valid_params }

      it 'マイページにリダイレクトされること' do is_expected.to redirect_to authenticated_root_path end
    end

    context 'ログインしていない場合' do
      context '不正な入力値の場合' do
        let(:params) { invalid_params }

        it 'ログイン画面が表示されること' do is_expected.to eq 200 end
      end

      context '正しい入力値の場合' do
        let(:params) { valid_params }

        it 'マイページにリダイレクトされること' do is_expected.to redirect_to authenticated_root_path end
      end

      context '正しい入力値の場合(Eメールを使用)' do
        let(:params) { valid_email_params }

        it 'マイページにリダイレクトされること' do is_expected.to redirect_to authenticated_root_path end
      end
    end
  end
end
