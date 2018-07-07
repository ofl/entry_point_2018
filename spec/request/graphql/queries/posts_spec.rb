require 'rails_helper'

RSpec.describe 'Queries::Posts', type: :request do
  subject { post graphql_path, params: { query: query } }

  let!(:user) { create(:user) }
  let!(:post_data) { create(:post, user: user) }
  let!(:comment) { create(:comment, post: post_data) }

  describe 'show' do
    let(:query) do
      <<~QUERY
        {
          post(id: #{id}) {
            id
            title
            body
            user {
              username
            }
            comments {
              body
            }
          }
        }
      QUERY
    end

    context 'idに該当する投稿が存在する時' do
      let(:id) { post_data.id }

      it '投稿のデータが返ること' do
        subject
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:post][:id]).to eq post_data.id.to_s
        expect(json[:data][:post][:title]).to eq post_data.title
        expect(json[:data][:post][:body]).to eq post_data.body
        expect(json[:data][:post][:user][:username]).to eq user.username
        expect(json[:data][:post][:comments][0][:body]).to eq comment.body
      end
    end

    context 'idに該当する投稿が存在しない時' do
      let(:id) { 999_999 }

      it 'nilが返ること' do
        subject
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:post]).to be_nil
      end
    end
  end

  describe 'index' do
    let(:query) do
      <<~QUERY
        {
          posts {
            id
            title
            body
            user {
              username
            }
          }
        }
      QUERY
    end

    context 'idに該当する投稿が存在する時' do
      let(:id) { post_data.id }

      it '投稿のデータが返ること' do
        subject
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:posts][0][:id]).to eq post_data.id.to_s
        expect(json[:data][:posts][0][:title]).to eq post_data.title
        expect(json[:data][:posts][0][:body]).to eq post_data.body
        expect(json[:data][:posts][0][:user][:username]).to eq user.username
      end
    end
  end
end
