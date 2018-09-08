require 'rails_helper'

RSpec.describe 'ポイント履歴について', type: :request do
  let!(:user) { create(:user) }
  let!(:point_history) { create(:point_history, :got, amount: 1000, user: user) }
  let!(:other_point_history) { create(:point_history, :got, amount: 1000, user: create(:user)) }

  describe 'GET /point_histories' do
    subject { get point_histories_path, params: params }

    let(:params) { {} }

    it_behaves_like 'ログインが必要なリクエスト'

    context 'ログインしている場合' do
      before { sign_in user }

      it '一覧が表示されること' do is_expected.to eq 200 end
    end
  end

  describe 'GET /point_histories/:id' do
    subject { get point_history_path(params) }

    let(:params) { { id: point_history.id } }

    it_behaves_like 'ログインが必要なリクエスト'

    context 'ログインしている場合' do
      before { sign_in user }

      context 'ポイント履歴が存在しない場合' do
        let(:params) { { id: 999_999 } }

        it '404エラーになること' do
          is_expected.to eq 404
        end
      end

      context 'ポイント履歴が存在する場合' do
        it '詳細が表示されること' do is_expected.to eq 200 end
      end

      context '他のユーザーのポイント履歴の場合' do
        let(:params) { { id: other_point_history.id } }

        it '404エラーになること' do
          is_expected.to eq 404
        end
      end
    end
  end
end
