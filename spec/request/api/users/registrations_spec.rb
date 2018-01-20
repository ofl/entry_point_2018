require 'rails_helper'

RSpec.describe 'registrations', type: :request do
  include ApiRequestSpecHelper

  let(:valid_params) { { user: { username: 'foo', email: 'foo@example.com', password: 'foobarbaz' } } }
  let(:invalid_params) { { user: { username: 'あああ', email: 'foo@example.com', password: 'ぱすわーど' } } }

  describe 'GET /api/users/registrations' do
    subject { get '/api/users/registrations', headers: headers }

    context 'not logged in' do
      it { is_expected.to eq 401 }
    end

    context 'logged in' do
      before { login }

      it do
        subject
        is_expected.to eq 200
        expect(json).to match(registrant_structure)
      end
    end
  end

  describe 'POST /api/users/registrations' do
    subject { post '/api/users/registrations', params: params }

    context 'no params' do
      it { is_expected.to eq 500 }

      it do
        subject
        expect(json['errors'][0]).to eq 'param is missing or the value is empty: user'
      end
    end

    context 'valid params' do
      let(:params) { valid_params }

      it do
        subject
        is_expected.to eq 200
        expect(json).to match(registrant_structure)
      end

      it do
        expect do
          subject
        end.to change(User, :count).by(1)
      end
    end
  end

  describe 'PUT /api/users/registrations' do
    subject { put '/api/users/registrations', params: params.to_json, headers: headers }

    context 'not logged in' do
      it { is_expected.to eq 401 }
    end

    context 'logged in' do
      before { login }

      context 'no params' do
        it { is_expected.to eq 500 }

        it do
          subject
          expect(json['errors'][0]).to eq 'param is missing or the value is empty: user'
        end
      end

      context 'valid params' do
        let(:params) { valid_params }

        it do
          subject
          is_expected.to eq 200
          expect(json).to match(registrant_structure)
        end
      end

      context 'invalid params' do
        let(:params) { invalid_params }

        it do
          subject
          is_expected.to eq 422
          expect(json['errors'][0]).to include 'バリデーションに失敗しました'
        end
      end
    end
  end

  describe 'DELETE /api/users/registrations' do
    subject { delete '/api/users/registrations', headers: headers }

    context 'not logged in' do
      it { is_expected.to eq 401 }
    end

    context 'logged in' do
      before { login }

      let(:params) { valid_params }

      it do
        subject
        is_expected.to eq 200
      end

      it do
        expect { subject }.to change(User, :count).by(-1)
      end
    end
  end
end
