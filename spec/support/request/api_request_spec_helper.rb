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

    shared_examples 'ログインが必要なAPIへのリクエスト' do
      it '401エラーになること' do
        is_expected.to eq 401
        expect(json['errors'][0]['title']).to eq I18n.t('application_errors.unauthorized')
      end
    end

    shared_examples '権限が必要なAPIへのリクエスト' do
      it '403エラーになること' do
        is_expected.to eq 403
        expect(json['errors'][0]['title']).to eq I18n.t('application_errors.forbidden')
      end
    end
  end

  private

  def json
    @json ||= JSON.parse(response.body)
  end

  def data_id
    json['data']['id']
  end

  def data_type
    json['data']['type']
  end

  def data_attributes
    json['data']['attributes']
  end

  def login
    login_user.save
  end
end
