require 'rails_helper'

RSpec.describe 'Users::Passwords', type: :request do
  let(:user) { create :user }

  describe 'GET /users/password/new' do
    subject { get new_user_password_path }

    context 'ログインしていない場合' do
      it '編集画面が表示されること' do is_expected.to eq 200 end
    end

    context 'ログインしている場合' do
      before { sign_in user }

      it 'マイページにリダイレクトされること' do is_expected.to redirect_to authenticated_root_path end
    end
  end

  describe 'POST /users/password' do
    subject { post user_password_path, params: params }

    let(:valid_params) { { user: { email: user.email } } }
    let(:invalid_params) { { user: { email: 'foo@example.com' } } }

    context 'ログインしている場合' do
      before { sign_in user }

      let(:params) { valid_params }

      it 'マイページにリダイレクトされること' do is_expected.to redirect_to authenticated_root_path end
    end

    context 'ログインしていない場合' do
      context '不正な入力値の場合' do
        let(:params) { invalid_params }

        it '編集画面が表示されること' do is_expected.to eq 200 end
      end

      context '正しい入力値の場合' do
        let(:params) { valid_params }

        it 'ログイン画面にリダイレクトされること' do is_expected.to redirect_to new_user_session_path end
        it 'パスワード変更メールは送信されないこと' do
          expect { subject }.to(change { ActionMailer::Base.deliveries.count })
        end
      end
    end
  end

  describe 'GET /users/password/edit' do
    subject { get edit_user_password_path, params: params }

    let(:valid_params) { { reset_password_token: 'abc' } }
    let(:invalid_params) { {} }

    context 'ログインしていない場合' do
      context '不正な入力値の場合' do
        let(:params) { invalid_params }

        it 'ログイン画面にリダイレクトされること' do is_expected.to redirect_to new_user_session_path end
      end

      context '正しい入力値の場合' do
        let(:params) { valid_params }

        it '編集画面が表示されること' do is_expected.to eq 200 end
      end
    end

    context 'ログインしている場合' do
      before { sign_in user }

      let(:params) { valid_params }

      it 'マイページにリダイレクトされること' do is_expected.to redirect_to authenticated_root_path end
    end
  end

  describe 'PUT /users/password' do
    subject { put user_password_path, params: params }

    let!(:token) { user.send_reset_password_instructions }

    let(:valid_params) do
      { user: { reset_password_token: token, password: 'foobarbaz', password_confirmation: 'foobarbaz' } }
    end
    let(:invalid_token_params) do
      { user: { reset_password_token: 'abc', password: 'foobarbaz', password_confirmation: 'foobarbaz' } }
    end
    let(:invalid_value_params) do
      { user: { reset_password_token: token, password: 'foobarbaz', password_confirmation: 'xxxxxxxxx' } }
    end

    context 'ログインしていない場合' do
      context '不正なトークンの場合' do
        let(:params) { invalid_token_params }

        it '編集画面が表示されること' do is_expected.to eq 200 end
      end

      context 'invalid value params' do
        let(:params) { invalid_value_params }

        it '編集画面が表示されること' do is_expected.to eq 200 end
      end

      context '正しい入力値の場合' do
        let(:params) { valid_params }

        it 'マイページにリダイレクトされること' do is_expected.to redirect_to authenticated_root_path end
      end
    end

    context 'ログインしている場合' do
      before { sign_in user }

      let(:params) { valid_params }

      it 'マイページにリダイレクトされること' do is_expected.to redirect_to authenticated_root_path end
    end
  end
end
