require 'rails_helper'

RSpec.describe 'registrations', type: :request do
  include ApiRequestSpecHelper

  let!(:point_history) { create(:point_history, :got, amount: 1000, user: login_user) }
  let(:another_user) { create :user }
  let!(:another_point_history) { create :point_history, :got, amount: 500, user: another_user }

  describe 'GET /api/point_histories' do
    subject { get api_point_histories_path, params: {}, headers: headers }

    context 'ログインしていない場合' do
      let(:headers) { {} }

      it_behaves_like 'ログインが必要なAPIへのリクエスト'
    end

    context 'ログインしている場合' do
      it 'ポイント情報を取得できること' do
        subject
        is_expected.to eq 200
        expect(json).to eq(
          [
            {
              'amount' => 1000,
              'id' => point_history.id,
              'operation_type' => 'got',
              'total' => 1000
            }
          ]
        )
      end
    end
  end

  describe 'GET /api/point_histories/:id' do
    subject { get api_point_history_path(id: id), params: params, headers: headers }
    let(:params) { {} }
    let(:id) { point_history.id }

    context 'ログインしていない場合' do
      let(:headers) { {} }

      it_behaves_like 'ログインが必要なAPIへのリクエスト'
    end

    context 'ログインしている場合' do
      context '自分のポイントを参照するとき' do
        it 'ポイント情報を取得できること' do
          subject
          is_expected.to eq 200
          expect(json).to eq(
            'amount' => 1000,
            'id' => point_history.id,
            'operation_type' => 'got',
            'total' => 1000
          )
        end
      end

      context '他人のポイントを参照するとき' do
        let(:id) { another_point_history.id }

        it_behaves_like '権限が必要なAPIへのリクエスト'
      end
    end
  end
end
