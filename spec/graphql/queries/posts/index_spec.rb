require 'rails_helper'

RSpec.describe 'Queries::Posts::Index' do # rubocop:disable RSpec/DescribeClass
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

  let(:expected_value) do
    {
      posts: [
        {
          id: post.id.to_s,
          title: post.title,
          user: {
            username: user.username
          }
        }
      ]
    }.deep_stringify_keys
  end

  it '投稿のデータが返ること' do
    expect(data).to eq expected_value
  end
end
