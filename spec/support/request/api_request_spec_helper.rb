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

    shared_examples '認証が必要なエンドポイントに認証せずにアクセスした場合' do
      it { is_expected.to eq 401 }

      it 'エラーメッセージが返ること' do
        subject
        expect(json['errors'][0]['title']).to eq I18n.t('application_errors.unauthorized')
      end
    end

    shared_examples '権限が必要なエンドポイントに権限を持たないユーザーがアクセスした場合' do
      it { is_expected.to eq 403 }

      it 'エラーメッセージが返ること' do
        subject
        expect(json['errors'][0]['title']).to eq I18n.t('application_errors.forbidden')
      end
    end

    shared_examples '入力内容をチェックされるエンドポイントで不正な値を入力した場合' do
      it { is_expected.to eq 422 }

      it 'エラーメッセージが返ること' do
        subject
        expect(json['errors'][0]['title']).to include 'バリデーションに失敗しました'
      end
    end

    shared_examples 'エンドポイントに必須のパラメータを渡さなかった場合' do |required|
      it { is_expected.to eq 400 }

      it 'エラーメッセージが返ること' do
        subject
        expect(json['errors'][0]['title']).to eq "param is missing or the value is empty: #{required}"
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
