require 'rails_helper'

RSpec.describe 'Queries::Users::Show' do
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

    it 'ユーザーのデータが返ること' do
      expect(data[:user][:id]).to eq user.id.to_s
      expect(data[:user][:username]).to eq user.username

      expect(errors).to be_nil
    end
  end

  context 'usernameに該当するユーザーが存在しない時' do
    let(:username) { 'foo_bar_baz' }

    it 'nilが返ること' do
      expect(data[:user]).to be_nil

      expect(errors).to be_nil
    end
  end
end
