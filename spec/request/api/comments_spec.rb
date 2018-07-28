require 'rails_helper'

RSpec.describe 'comments', type: :request do
  include ApiRequestSpecHelper

  let(:user) { create :user }
  let!(:post_data) { create :post }
  let!(:comment) { create :comment, user: user }
  let(:another_comment) { create :comment }

  let(:id) { comment.id }
  let(:post_id) { post_data.id }
  let(:valid_params_on_create) { { post_id: post_id, body: 'foo bar baz' } }
  let(:valid_params) { { body: 'fuga hoge' } }
  let(:invalid_params) { { body: '' } }

  let(:comment_structure) do
    {
      'username' => a_kind_of(String),
      'body' => a_kind_of(String),
      'created_at' => a_kind_of(String),
      'updated_at' => a_kind_of(String)
    }
  end

  describe 'POST /api/comments' do
    subject { post api_comments_path, params: params.to_json, headers: headers }

    context 'ログインしていない場合' do
      let(:params) { valid_params }

      it_behaves_like 'ログインが必要なAPIへのリクエスト'
    end

    context 'ログインしている場合' do
      let(:user) { login_user }

      context '入力値がない場合' do
        it '400エラーになること' do
          is_expected.to eq 400
          expect(json['errors'][0]['title']).to eq 'param is missing or the value is empty: comment'
        end
      end

      context '正しい入力値の場合' do
        let(:params) { valid_params_on_create }

        it 'コメントが登録されること' do
          subject
          is_expected.to eq 201
          expect(data_type).to eq 'comment'
          expect(data_attributes).to match(comment_structure)
        end

        it 'コメントが増加すること' do
          expect do
            subject
          end.to change(Comment, :count).by(1)
        end
      end

      context '不正な入力値の場合' do
        let(:params) { invalid_params }

        it '422エラーになること' do
          subject
          is_expected.to eq 422
          expect(json['errors'][0]['title']).to include 'バリデーションに失敗しました'
        end
      end
    end
  end

  describe 'PUT /api/comments/:id' do
    subject { put api_comment_path(id: id), params: params.to_json, headers: headers }

    context 'ログインしていない場合' do
      let(:params) { valid_params }

      it_behaves_like 'ログインが必要なAPIへのリクエスト'
    end

    context 'ログインしている場合' do
      let(:user) { login_user }

      context '入力値がない場合' do
        it '400エラーになること' do
          is_expected.to eq 400
          expect(json['errors'][0]['title']).to eq 'param is missing or the value is empty: comment'
        end
      end

      context '正しい入力値の場合' do
        let(:params) { valid_params }

        it 'コメントが修正されること' do
          subject
          is_expected.to eq 200
          expect(data_type).to eq 'comment'
          expect(data_attributes).to match(comment_structure)
          expect(data_attributes['body']).to eq valid_params[:body]
        end
      end

      context '不正な入力値の場合' do
        let(:params) { invalid_params }

        it '422エラーになること' do
          subject
          is_expected.to eq 422
          expect(json['errors'][0]['title']).to include 'バリデーションに失敗しました'
        end
      end
    end
  end

  describe 'DELETE /api/comments/:id' do
    subject { delete api_comment_path(id: id), params: {}, headers: headers }

    context 'ログインしていない場合' do
      it_behaves_like 'ログインが必要なAPIへのリクエスト'
    end

    context 'ログインしている場合' do
      let(:user) { login_user }

      context '自分のコメントのとき' do
        it 'コメントが削除されること' do
          subject
          is_expected.to eq 200
        end

        it 'コメントが減少すること' do
          expect { subject }.to change(Comment, :count).by(-1)
        end
      end

      context '削除する権限がないとき' do
        let(:id) { another_comment.id }

        it_behaves_like '権限が必要なAPIへのリクエスト'
      end
    end
  end
end
