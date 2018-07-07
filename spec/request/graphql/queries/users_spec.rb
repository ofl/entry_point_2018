require 'rails_helper'

RSpec.describe 'Queries::Users', type: :request do
  subject { post graphql_path, params: { query: query } }

  let!(:user) { create(:user) }

  describe 'show' do
    let(:query) do
      <<~QUERY
        {
          user(username: #{username}) {
            id
            email
            username
          }
        }
      QUERY
    end

    context 'usernameに該当するユーザーが存在する時' do
      let(:username) { user.username }

      it 'ユーザーのデータが返ること' do
        subject
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:user][:id]).to eq user.id.to_s
        expect(json[:data][:user][:email]).to eq user.email
        expect(json[:data][:user][:username]).to eq user.username
      end
    end

    context 'usernameに該当するユーザーが存在しない時' do
      let(:username) { 'foo_bar_baz' }

      it 'nilが返ること' do
        subject
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:user]).to be_nil
      end
    end
  end

  describe 'current' do
    let(:query) do
      <<~QUERY
        {
          currentUser {
            id
            email
            username
          }
        }
      QUERY
    end

    context 'ログインしている時' do
      before { sign_in user }

      it 'ユーザーのデータが返ること' do
        subject
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:currentUser][:id]).to eq user.id.to_s
        expect(json[:data][:currentUser][:email]).to eq user.email
        expect(json[:data][:currentUser][:username]).to eq user.username
      end
    end

    context 'ログインしていない時' do
      it 'ゲストユーザーのデータが返ること' do
        subject
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:currentUser][:id]).to be_nil
        expect(json[:data][:currentUser][:email]).to be_nil
        expect(json[:data][:currentUser][:username]).to eq 'Guest'
      end
    end
  end
end
