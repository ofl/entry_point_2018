require 'rails_helper'

RSpec.describe 'Home', type: :request do
  describe 'GET /' do
    subject { get root_path }

    it 'ホームが表示されること' do
      subject
      expect(response.body).to include 'EntryPoint2018'
      # is_expected.to eq 200
    end
  end
end
