require 'rails_helper'

RSpec.describe 'Mypage', type: :request do
  describe 'GET /' do
    let!(:user) { create :user }
    subject { get root_path }

    context 'not logged in' do
      it { is_expected.to eq 200 }

      it do
        subject
        expect(response.body).not_to include user.username
      end
    end

    context 'logged in' do
      before { sign_in(user) }

      it { is_expected.to eq 200 }

      it do
        subject
        expect(response.body).to include user.username
      end
    end
  end
end
