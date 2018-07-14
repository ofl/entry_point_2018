require 'rails_helper'

RSpec.describe 'Queries::Posts::Show' do
  include GraphqlSpecHelper

  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:comment) { create(:comment, post: post) }

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

    it '投稿のデータが返ること' do
      expect(data[:post][:id]).to eq post.id.to_s
      expect(data[:post][:title]).to eq post.title
      expect(data[:post][:body]).to eq post.body
      expect(data[:post][:user][:username]).to eq user.username
      expect(data[:post][:comments][0][:body]).to eq comment.body

      expect(errors).to be_nil
    end
  end

  context 'idに該当する投稿が存在しない時' do
    let(:id) { 999_999 }

    it 'GraphQL::ExecutionErrorが返ること' do
      expect(data).to be_nil

      expect(errors[0][:message]).to eq "ID=`#{id}`の投稿は見つかりません"
      expect(errors[0][:path]).to eq ['post']
    end
  end
end
