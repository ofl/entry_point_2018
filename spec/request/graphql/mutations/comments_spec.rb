require 'rails_helper'

RSpec.describe 'Mutations::Comments', type: :request do
  subject { post graphql_path, params: { query: query } }

  let!(:user) { create(:user) }
  let!(:post_data) { create(:post) }

  describe 'create' do
    let(:query) do
      <<~QUERY
        mutation {
          createComment(input: {postId: #{post_id}, body: "#{body}"}) {
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

    let(:body) { 'foo bar baz' }

    context 'ログインしている時' do
      before { sign_in user }

      context 'post_idに該当する投稿が存在する時' do
        let(:post_id) { post_data.id }

        it 'コメントのデータが返ること' do
          subject
          json = JSON.parse(response.body, symbolize_names: true)
          expect(json[:data][:createComment][:comment][:body]).to eq body
          expect(json[:data][:createComment][:comment][:user][:username]).to eq user.username
          expect(json[:data][:createComment][:errors]).to be_blank
        end

        it 'コメントが１件増えること' do
          expect { subject }.to change(Comment, :count).by(1)
        end
      end

      context 'post_idに該当する投稿が存在しない時' do
        let(:post_id) { 999_999 }

        it 'Types::UserErrorが返ること' do
          subject
          json = JSON.parse(response.body, symbolize_names: true)
          expect(json[:data][:createComment][:comment]).to be_nil
          expect(json[:data][:createComment][:errors][0][:path]).to eq %w[attributes post]
          expect(json[:data][:createComment][:errors][0][:message]).to eq 'を入力してください'
        end
      end
    end

    context 'ログインしていない時' do
      let(:post_id) { post_data.id }

      it 'GraphQL::ExecutionErrorが返ること' do
        subject
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:createComment]).to be_nil
        expect(json[:errors][0][:message]).to eq 'ログインが必要です'
        expect(json[:errors][0][:path]).to eq ['createComment']
      end
    end
  end
end
