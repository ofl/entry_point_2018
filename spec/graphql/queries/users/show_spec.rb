require 'rails_helper'

RSpec.describe 'Queries::Users::Show' do # rubocop:disable RSpec/DescribeClass
  include GraphqlSpecHelper

  let!(:user) { create(:user) }

  let(:query) do
    <<~QUERY
      query User($username: String!){
        user(username: $username) {
          id
          username
        }
      }
    QUERY
  end
  let(:operation_name) { 'User' }
  let(:variables) { { username: username } }

  context 'usernameに該当するユーザーが存在する時' do
    let(:username) { user.username }
    let(:expected_value) do
      {
        user: {
          id: user.id.to_s,
          username: user.username
        }
      }.deep_stringify_keys
    end

    it 'ユーザーのデータが返ること' do
      expect(data).to eq expected_value
    end
  end

  context 'usernameに該当するユーザーが存在しない時' do
    let(:username) { 'foo_bar_baz' }

    let(:expected_value) do
      { user: nil }.deep_stringify_keys
    end

    it 'ユーザーのデータが返ること' do
      expect(data).to eq expected_value
    end
  end
end
