require 'rails_helper'

RSpec.describe 'Mypage', type: :request do
  describe 'GET /' do
    subject { get root_path }

    let!(:user) { create :user }

    context 'ログインしていない場合' do
      it { is_expected.to eq 200 }

      it 'ホームが表示されること' do
        subject
        expect(response.body).to include I18n.t('layouts.application.sign_in')
      end
    end

    context 'ログインしている場合' do
      before { sign_in(user) }

      it { is_expected.to eq 200 }

      it 'マイページが表示されること' do
        subject
        expect(response.body).to include I18n.t('layouts.application.sign_out')
      end
    end
  end
end
