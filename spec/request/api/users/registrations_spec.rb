require 'rails_helper'

RSpec.describe 'registrations', type: :request do
  include ApiRequestSpecHelper

  describe 'GET /api/users/registrations' do
    subject { get '/api/users/registrations', headers: headers }

    context 'ログインしていない場合' do
      it '401エラーになること' do
        is_expected.to eq 401
      end
    end

    context 'ログインしている場合' do
      before { login }

      it 'ユーザー情報を取得できること', autodoc: true do
        subject
        is_expected.to eq 200
        expect(json).to match(registrant_structure)
      end
    end
  end

  describe 'POST /api/users/registrations' do
    let(:valid_params) { { user: { username: 'foo', email: 'foo@example.com', password: 'foobarbaz' } } }
    let(:invalid_params) { { user: { username: 'あああ', email: 'foo@example.com', password: 'ぱすわーど' } } }
    let(:headers) do
      {
        accept: 'application/json',
        'Content-Type': 'application/json'
      }
    end

    subject { post '/api/users/registrations', params: params.to_json, headers: headers }

    context '入力値がない場合' do
      it '500エラーになること' do
        is_expected.to eq 500
        expect(json['errors'][0]).to eq 'param is missing or the value is empty: user'
      end
    end

    context '正しい入力値の場合' do
      let(:params) { valid_params }

      it 'ユーザーが登録されること', autodoc: true do
        subject
        is_expected.to eq 200
        expect(json).to match(registrant_structure)
      end

      it 'ユーザーが増加すること' do
        expect do
          subject
        end.to change(User, :count).by(1)
      end
    end

    context '不正な入力値の場合' do
      let(:params) { invalid_params }

      it '422エラーになること' do
        subject
        is_expected.to eq 422
        expect(json['errors'][0]).to include 'バリデーションに失敗しました'
      end
    end
  end

  describe 'PUT /api/users/registrations' do
    let(:valid_params) { { user: { username: 'foo', email: 'foo@example.com', password: 'foobarbaz' } } }
    let(:invalid_params) { { user: { username: 'あああ', email: 'foo@example.com', password: 'ぱすわーど' } } }

    subject { put '/api/users/registrations', params: params.to_json, headers: headers }

    context 'ログインしていない場合' do
      it '401エラーになること' do
        is_expected.to eq 401
      end
    end

    context 'ログインしている場合' do
      before { login }

      context '入力値がない場合' do
        it '500エラーになること' do
          is_expected.to eq 500
          expect(json['errors'][0]).to eq 'param is missing or the value is empty: user'
        end
      end

      context '正しい入力値の場合' do
        let(:params) { valid_params }

        it 'ユーザー情報が修正されること', autodoc: true do
          subject
          is_expected.to eq 200
          expect(json).to match(registrant_structure)
        end
      end

      context '不正な入力値の場合' do
        let(:params) { invalid_params }

        it '422エラーになること' do
          subject
          is_expected.to eq 422
          expect(json['errors'][0]).to include 'バリデーションに失敗しました'
        end
      end
    end
  end

  describe 'DELETE /api/users/registrations' do
    subject { delete '/api/users/registrations', headers: headers }

    context 'ログインしていない場合' do
      it '401エラーになること' do
        is_expected.to eq 401
      end
    end

    context 'ログインしている場合' do
      before { login }

      it 'ユーザーが削除されること', autodoc: true do
        subject
        is_expected.to eq 200
      end

      it 'ユーザーが減少すること' do
        expect { subject }.to change(User, :count).by(-1)
      end
    end
  end
end
