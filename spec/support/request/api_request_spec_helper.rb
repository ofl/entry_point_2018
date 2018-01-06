require 'active_support/concern'

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

    let(:registrant_structure) do
      {
        'id' => a_kind_of(Integer),
        'username' => a_kind_of(String).or(a_nil_value),
        'email' => a_kind_of(String).or(a_nil_value),
        'authentication_token' => a_kind_of(String),
        'confirmed_by_email' => be_in([true, false]),
        'confirmed_by_twitter' => be_in([true, false]),
        'confirmed_by_facebook' => be_in([true, false]),
        'created_at' => a_kind_of(String),
        'updated_at' => a_kind_of(String)
      }
    end

    def json
      @json ||= JSON.parse(response.body)
    end

    def login
      login_user.save
    end
  end
end
