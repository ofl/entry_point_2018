require 'rails_helper'

RSpec.describe 'Queries::Users::CurrentUser' do
  include GraphqlSpecHelper

  let!(:user) { create(:user) }

  let(:query) do
    <<~QUERY
      query CurrentUser{
        currentUser {
          id
          username
        }
      }
    QUERY
  end
  let(:operation_name) { 'CurrentUser' }
  let(:context) { { current_user: user } }

  it 'ユーザーのデータが返ること' do
    expect(data[:currentUser][:id]).to eq user.id.to_s
    expect(data[:currentUser][:username]).to eq user.username

    expect(errors).to be_nil
  end
end
