require 'rails_helper'

RSpec.describe 'Queries::Posts::Index' do
  include GraphqlSpecHelper

  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }

  let(:query) do
    <<~QUERY
      query Posts {
        posts {
          id
          title
          user {
            username
          }
        }
      }
    QUERY
  end
  let(:operation_name) { 'Posts' }

  it '投稿のデータが返ること' do
    expect(data[:posts][0][:id]).to eq post.id.to_s
    expect(data[:posts][0][:title]).to eq post.title
    expect(data[:posts][0][:user][:username]).to eq user.username

    expect(errors).to be_nil
  end
end
