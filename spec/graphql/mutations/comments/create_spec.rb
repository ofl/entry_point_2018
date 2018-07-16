require 'rails_helper'

RSpec.describe 'Mutations::Comments::Create' do
  include GraphqlSpecHelper

  let!(:user) { create(:user) }
  let!(:post_data) { create(:post) }

  let(:query) do
    <<~QUERY
      mutation CreateComment($variables:createCommentInput!) {
        createComment(input: $variables) {
          comment {
            id
            body
            user {
              id
              username
            }
          }
        }
      }
    QUERY
  end
  let(:operation_name) { 'CreateComment' }
  let(:variables) do
    {
      'variables': {
        'attributes': {
          'postId': post_id,
          'body': body
        }
      }
    }
  end

  let(:post_id) { post_data.id }
  let(:body) { 'foo bar baz' }

  context 'ログインしている時' do
    let(:query_context) { { current_user: user } }

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

      it 'Errorが返ること' do
        expect(data[:createComment]).to be_nil
        expect(errors[0][:message]).to eq 'を入力してください'
        expect(errors[0][:extensions][:code]).to eq 'BAD_USER_INPUT'
        expect(errors[0][:extensions][:path]).to eq %w[attributes post]
      end

      it 'コメントが増えないこと' do
        expect { subject }.not_to change(Comment, :count)
      end
    end

    context 'bodyが空文字列だった場合' do
      let(:body) { '' }

      it 'Errorが返ること' do
        expect(data[:createComment]).to be_nil
        expect(errors[0][:message]).to eq 'を入力してください'
        expect(errors[0][:extensions][:code]).to eq 'BAD_USER_INPUT'
        expect(errors[0][:extensions][:path]).to eq %w[attributes body]
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
