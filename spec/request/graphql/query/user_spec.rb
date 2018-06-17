require 'rails_helper'

RSpec.describe 'user query', type: :request do
  subject { post graphql_path, params: { query: query } }

  let!(:user) { create(:user) }

  let(:query) do
    <<~QUERY
      {
        user(username: #{user.username}) {
          id
          email
          username
        }
      }
    QUERY
  end

  it 'response body is User data' do
    subject
    json = JSON.parse(response.body, symbolize_names: true)
    expect(json[:data][:user][:id]).to eq user.id.to_s
    expect(json[:data][:user][:email]).to eq user.email
    expect(json[:data][:user][:username]).to eq user.username
  end
end
