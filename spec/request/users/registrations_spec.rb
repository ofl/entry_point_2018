require 'rails_helper'

RSpec.describe 'Users::Registrations', type: :request do
  let!(:user) { create :user }

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
    let(:valid_params) { { user: { username: 'foo', email: 'foo@sample.com', password: 'password' } } }
    let(:invalid_params) { { user: { username: 'foo', email: user.email, password: 'a' } } }

    context 'logged in' do
      let(:params) { valid_params }
      before { sign_in user }

      it { is_expected.to redirect_to authenticated_root_path }
      it { expect { subject }.not_to change(User, :count) }
    end

    context 'not logged in' do
      context 'invalid params' do
        let(:params) { invalid_params }

        it { is_expected.to eq 200 }
      end

      context 'valid params' do
        context 'preview' do
          let(:params) { valid_params.merge(preview: true) }

          it { is_expected.to eq 200 }
          it { expect { subject }.not_to change(User, :count) }
        end

        context 'auth_via_email' do
          let(:params) { valid_params.merge(auth_via_email: true) }

          it { is_expected.to redirect_to authenticated_root_path }
          it { expect { subject }.to change(User, :count).by(1) }
        end
      end
    end
  end

  describe 'DELETE /users/registration' do
    subject { delete user_registration_path, params: params }
    let(:valid_params) { { user: { password: 'password' } } }
    let(:invalid_params) { { user: { password: 'a' } } }

    context 'ログインしている場合' do
      before { sign_in user }

      context '正しいパスワードを入力した場合' do
        let(:params) { valid_params }

        it 'ルート画面にリダイレクトされること' do
          is_expected.to redirect_to root_path
        end

        it 'ユーザーが削除されること' do
          subject
          expect(User.find_by(id: user.id)).to be_nil
        end

        it 'ユーザー数が-1になること' do
          expect { subject }.to change(User, :count).by(-1)
        end
      end

      context '不正なパスワードを入力した場合' do
        let(:params) { invalid_params }

        it '退会画面に戻ること' do
          expect(subject).to eq 200
        end

        it '「パスワードは不正な値です」と表示されること' do
          subject
          expect(response.body).to include 'パスワードは不正な値です'
        end

        it 'ユーザー数は変化しないこと' do
          expect { subject }.not_to change(User, :count)
        end
      end
    end

    context 'ログインしていない場合' do
      let(:params) { valid_params }

      it 'ログイン画面にリダイレクトされること' do
        is_expected.to redirect_to new_user_session_path
      end
    end
  end
end
