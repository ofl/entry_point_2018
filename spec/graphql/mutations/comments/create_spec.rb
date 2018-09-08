require 'rails_helper'

RSpec.describe 'Mutations::Comments::Create' do # rubocop:disable RSpec/DescribeClass
  include GraphqlSpecHelper

  let!(:user) { create(:user) }
  let!(:post_data) { create(:post) }

  let(:query) do
    <<~QUERY
      mutation CreateComment($variables:createCommentInput!) {
        createComment(input: $variables) {
          comment {
            body
            user {
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
      let(:expected_value) do
        {
          createComment: {
            comment: {
              body: body,
              user: {
                username: user.username
              }
            }
          }
        }.deep_stringify_keys
      end

      it 'コメントのデータが返ること' do
        expect(data).to eq expected_value
      end

      it 'コメントが１件増えること' do
        expect { subject }.to change(Comment, :count).by(1)
      end
    end

    context 'post_idに該当する投稿が存在しない時' do
      let(:post_id) { 999_999 }

      let(:expected_value) do
        {
          message: 'バリデーションに失敗しました: Postを入力してください, Postを入力してください',
          path: [],
          extensions: {
            title: 'バリデーションに失敗しました: Postを入力してください, Postを入力してください',
            detail: 'を入力してください',
            source: {
              pointer: '/data/attributes/post'
            },
            status: 400,
            code: 'BAD_REQUEST'
          }
        }.deep_stringify_keys
      end

      it 'Errorが返ること' do
        expect(errors[0]).to eq expected_value
      end

      it 'コメントが増えないこと' do
        expect { subject }.not_to change(Comment, :count)
      end
    end

    context 'bodyが空文字列だった場合' do
      let(:body) { '' }

      let(:expected_value) do
        {
          message: 'バリデーションに失敗しました: 本文を入力してください',
          path: [],
          extensions: {
            title: 'バリデーションに失敗しました: 本文を入力してください',
            detail: 'を入力してください',
            source: {
              pointer: '/data/attributes/body'
            },
            status: 400,
            code: 'BAD_REQUEST'
          }
        }.deep_stringify_keys
      end

      it 'Errorが返ること' do
        expect(errors[0]).to eq expected_value
      end

      it 'コメントが増えないこと' do
        expect { subject }.not_to change(Comment, :count)
      end
    end
  end

  context 'ログインしていない時' do
    let(:post_id) { post_data.id }

    let(:expected_value) do
      {
        message: I18n.t('application_errors.unauthorized'),
        path: ['createComment'],
        locations: [{ line: 2, column: 3 }],
        extensions: {}
      }.deep_stringify_keys
    end

    it 'GraphQL::ExecutionErrorが返ること' do
      expect(errors[0]).to eq expected_value
    end
  end
end
