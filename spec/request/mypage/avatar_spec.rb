require 'rails_helper'

RSpec.describe 'Mypage::Avatar', type: :request do
  describe 'GET /mypage/avatar/edit' do
    let!(:user) { create :user }
    subject { get edit_mypage_avatar_path }

    context 'ログインしていない場合' do
      it 'ログイン画面にリダイレクトされること' do
        expect(subject).to redirect_to(new_user_session_path)
      end
    end

    context 'ログインしている場合' do
      before { sign_in(user) }

      it 'プロフィール編集画面が表示されること' do
        is_expected.to eq 200
        expect(response.body).to include 'プロフィール編集'
      end
    end
  end

  describe ' PUT /mypage/avatar' do
    let!(:user) { create :user }
    let(:image_file_path) { Rails.root.join('spec', 'fixtures', 'files', 'youngman_31.png') }
    let(:text_file_path) { Rails.root.join('spec', 'fixtures', 'files', 'foo.txt') }
    let(:params) { { user: { avatar: Rack::Test::UploadedFile.new(image_file_path, 'image/png') } } }

    subject { put mypage_avatar_path, params: params }

    context 'ログインしていない場合' do
      it 'ログイン画面にリダイレクトされること' do
        expect(subject).to redirect_to(new_user_session_path)
      end
    end

    context 'ログインしている場合' do
      before { sign_in(user) }

      context '画像ファイルを添付した場合' do
        it 'マイページにリダイレクトされること' do
          expect(subject).to redirect_to(authenticated_root_path)
        end

        it 'ファイルがアップロードされること' do
          subject
          expect(user.reload.avatar).not_to be_nil
        end
      end

      context '画像以外のファイルを添付した場合' do
        let(:params) { { user: { avatar: Rack::Test::UploadedFile.new(text_file_path, 'text/plain') } } }

        it 'エラーが表示されること' do
          is_expected.to eq 200
          expect(response.body).to include 'アバターは許可されていないMIMEタイプです'
        end

        it 'ファイルはアップロードされないこと' do
          subject
          expect(user.reload.avatar).to be_nil
        end
      end
    end
  end
end
