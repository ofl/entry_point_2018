require 'rails_helper'

RSpec.describe 'Mypage', type: :request do
  describe 'GET /' do
    let!(:user) { create :user }
    subject { get root_path }

    context 'ログインしていない場合' do
      it 'ホームが表示されること' do
        is_expected.to eq 200
        expect(response.body).not_to include user.username
      end
    end

    context 'ログインしている場合' do
      before { sign_in(user) }

      it 'マイページが表示されること' do
        is_expected.to eq 200
        expect(response.body).to include user.username
      end
    end
  end
end
