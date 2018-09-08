require 'rails_helper'

RSpec.describe 'Queries::Posts::Show' do # rubocop:disable RSpec/DescribeClass
  include GraphqlSpecHelper

  let!(:user) { create(:user) }
  let!(:user_2) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:comment) { create(:comment, post: post, user: user_2) }

  let(:query) do
    <<~QUERY
      query Post($id: ID!) {
        post(id: $id) {
          id
          title
          body
          user {
            id
            username
          }
          comments {
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

  let(:variables) { { id: id } }
  let(:operation_name) { 'Post' }

  context 'idに該当する投稿が存在する時' do
    let(:id) { post.id }
    let(:expected_value) do
      {
        post: {
          id: post.id.to_s,
          title: post.title,
          body: post.body,
          user: {
            id: user.id.to_s,
            username: user.username
          },
          comments: [
            {
              id: comment.id.to_s,
              user: {
                id: user_2.id.to_s,
                username: user_2.username
              },
              body: comment.body
            }
          ]
        }
      }.deep_stringify_keys
    end

    it '投稿のデータが返ること' do
      expect(data).to eq expected_value
    end
  end

  context 'idに該当する投稿が存在しない時' do
    let(:id) { 999_999 }

    let(:expected_value) do
      [
        {
          message: "Couldn't find Post with 'id'=#{id}",
          locations: [{ line: 2, column: 3 }],
          path: ['post'],
          extensions: {}
        }.deep_stringify_keys
      ]
    end

    it 'GraphQL::ExecutionErrorが返ること' do
      expect(errors).to eq expected_value
    end
  end
end
