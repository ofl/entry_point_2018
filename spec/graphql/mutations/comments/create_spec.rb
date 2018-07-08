require 'rails_helper'

RSpec.describe 'Mutations::Comments::Create' do
  include GraphqlSpecHelper

  let!(:user) { create(:user) }
  let!(:post_data) { create(:post) }

  let(:query) do
    <<~QUERY
      mutation CreateComment($post_id:ID!, $body: String!) {
        createComment(input: {postId: $post_id, body: $body}) {
          comment {
            id
            body
            user {
              id
              username
            }
          }
          errors {
            path
            message
          }
        }
      }
    QUERY
  end
  let(:operation_name) { 'CreateComment' }
  let(:variables) { { post_id: post_id, body: body } }

  let(:post_id) { post_data.id }
  let(:body) { 'foo bar baz' }

  context 'ログインしている時' do
    let(:context) { { current_user: user } }

    context '入力値が正しい場合' do
      it 'コメントのデータが返ること' do
        expect(data[:createComment][:comment][:body]).to eq body
        expect(data[:createComment][:comment][:user][:username]).to eq user.username
        expect(data[:createComment][:errors]).to be_blank
      end

      it 'コメントが１件増えること' do
        expect { subject }.to change(Comment, :count).by(1)
      end
    end

    context 'post_idに該当する投稿が存在しない時' do
      let(:post_id) { 999_999 }

      it 'Types::UserErrorが返ること' do
        expect(data[:createComment][:comment]).to be_nil
        expect(data[:createComment][:errors][0][:path]).to eq %w[attributes post]
        expect(data[:createComment][:errors][0][:message]).to eq 'を入力してください'
      end

      it 'コメントが増えないこと' do
        expect { subject }.not_to change(Comment, :count)
      end
    end

    context 'bodyが空文字列だった場合' do
      let(:body) { '' }

      it 'Types::UserErrorが返ること' do
        expect(data[:createComment][:comment]).to be_nil
        expect(data[:createComment][:errors][0][:path]).to eq %w[attributes body]
        expect(data[:createComment][:errors][0][:message]).to eq 'を入力してください'
      end

      it 'コメントが増えないこと' do
        expect { subject }.not_to change(Comment, :count)
      end
    end
  end

  context 'ログインしていない時' do
    let(:post_id) { post_data.id }

    it 'GraphQL::ExecutionErrorが返ること' do
      expect(data[:createComment]).to be_nil

      expect(errors[0][:message]).to eq 'ログインが必要です'
      expect(errors[0][:path]).to eq ['createComment']
    end
  end
end
