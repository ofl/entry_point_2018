module ApiRequestSpecHelper
  extend ActiveSupport::Concern

  included do
    let(:login_user) { build(:user, :confirmed) }
    let(:params) { {} }
    let(:headers) do
      {
        accept: 'application/json',
        authorization: login_user.authentication_token,
        username: login_user.username,
        'Content-Type': 'application/json'
      }
    end
  end

  private

  def json
    @json ||= JSON.parse(response.body)
  end

  def login
    login_user.save
  end
end
