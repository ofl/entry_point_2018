require 'rails_helper'

RSpec.describe 'Users::Registrations', type: :request do
  let!(:user) { create :user }

  describe 'GET /users/registration/new' do
    subject { get new_user_registration_path }

    context 'ログインしていない場合' do
      it '編集画面が表示されること' do is_expected.to eq 200 end
    end

    context 'ログインしている場合' do
      before { sign_in user }

      it 'マイページにリダイレクトされること' do is_expected.to redirect_to authenticated_root_path end
    end
  end

  describe 'POST /users/registration' do
    subject { post user_registration_path, params: params }
    let(:valid_params) { { user: { username: 'foo', email: 'foo@sample.com', password: 'password' } } }
    let(:invalid_params) { { user: { username: 'foo', email: user.email, password: 'a' } } }

    context 'ログインしている場合' do
      let(:params) { valid_params }
      before { sign_in user }

      it 'マイページにリダイレクトされること' do is_expected.to redirect_to authenticated_root_path end
      it 'ユーザーが増加しないこと' do expect { subject }.not_to change(User, :count) end
    end

    context 'ログインしていない場合' do
      context '不正な入力値の場合' do
        let(:params) { invalid_params }

        it '編集画面が表示されること' do is_expected.to eq 200 end
      end

      context '正しい入力値の場合' do
        context '入力内容の確認の場合' do
          let(:params) { valid_params.merge(preview: true) }

          it '入力内容の確認画面が表示されること' do is_expected.to eq 200 end
          it 'ユーザーが増加しないこと' do expect { subject }.not_to change(User, :count) end
        end

        context 'メールで本人確認の場合' do
          let(:params) { valid_params.merge(auth_via_email: true) }

          it 'マイページにリダイレクトされること' do is_expected.to redirect_to authenticated_root_path end
          it 'ユーザーが増加すること' do expect { subject }.to change(User, :count).by(1) end
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
