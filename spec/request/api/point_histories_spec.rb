require 'rails_helper'

RSpec.describe 'registrations', type: :request do
  include ApiRequestSpecHelper

  let(:user) { create :user }
  let!(:point_history) { create(:point_history, :got, amount: 1000, user: user) }
  let(:another_user) { create :user }
  let!(:another_point_history) { create :point_history, :got, amount: 500, user: another_user }

  let(:point_history_structure) do
    {
      'id' => a_kind_of(Integer),
      'amount' => a_kind_of(Integer),
      'operation_type' => a_kind_of(String),
      'total' => a_kind_of(Integer),
      'created_at' => a_kind_of(String),
      'updated_at' => a_kind_of(String)
    }
  end

  describe 'GET /api/point_histories' do
    subject { get api_point_histories_path, params: {}, headers: headers }

    context 'ログインしていない場合' do
      it_behaves_like '認証が必要なエンドポイントに認証せずにアクセスした場合'
    end

    context 'ログインしている場合' do
      let(:user) { login_user }

      it { is_expected.to eq 200 }

      it 'ポイント情報を取得できること' do
        subject
        expect(json).to match([point_history_structure])
      end
    end
  end

  describe 'GET /api/point_histories/:id' do
    subject { get api_point_history_path(id: id), params: params, headers: headers }

    let(:params) { {} }
    let(:id) { point_history.id }

    context 'ログインしていない場合' do
      it_behaves_like '認証が必要なエンドポイントに認証せずにアクセスした場合'
    end

    context 'ログインしている場合' do
      let(:user) { login_user }

      context '自分のポイントを参照するとき' do
        it { is_expected.to eq 200 }

        it 'ポイント情報を取得できること' do
          subject
          expect(json).to match(point_history_structure)
        end
      end

      context '参照する権限がないとき' do
        let(:id) { another_point_history.id }

        it_behaves_like '権限が必要なエンドポイントに権限を持たないユーザーがアクセスした場合'
      end
    end
  end
end
