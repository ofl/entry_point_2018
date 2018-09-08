require 'rails_helper'

RSpec.describe 'registrations', type: :request do
  include ApiRequestSpecHelper

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

  describe 'GET /api/users/registrations' do
    subject { get '/api/users/registrations', params: {}, headers: headers }

    context 'ログインしていない場合' do
      it '401エラーになること' do
        is_expected.to eq 401
      end
    end

    context 'ログインしている場合' do
      before { login }

      it { is_expected.to eq 200 }

      it 'ユーザー情報を取得できること', autodoc: true do
        subject
        expect(json).to match(registrant_structure)
      end
    end
  end

  describe 'POST /api/users/registrations' do
    subject { post '/api/users/registrations', params: params.to_json, headers: headers }

    let(:valid_params) { { user: { username: 'foo', email: 'foo@example.com', password: 'foobarbaz' } } }
    let(:invalid_params) { { user: { username: 'あああ', email: 'foo@example.com', password: 'ぱすわーど' } } }
    let(:headers) do
      {
        accept: 'application/json',
        'Content-Type': 'application/json'
      }
    end

    context '入力値がない場合' do
      it_behaves_like 'エンドポイントに必須のパラメータを渡さなかった場合', 'user'
    end

    context '正しい入力値の場合' do
      let(:params) { valid_params }

      it { is_expected.to eq 200 }

      it 'ユーザーが登録されること', autodoc: true do
        subject
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

      it_behaves_like '入力内容をチェックされるエンドポイントで不正な値を入力した場合'
    end
  end

  describe 'PUT /api/users/registrations' do
    subject { put '/api/users/registrations', params: params.to_json, headers: headers }

    let(:valid_params) { { user: { username: 'foo', email: 'foo@example.com', password: 'foobarbaz' } } }
    let(:invalid_params) { { user: { username: 'あああ', email: 'foo@example.com', password: 'ぱすわーど' } } }

    context 'ログインしていない場合' do
      it { is_expected.to eq 401 }
    end

    context 'ログインしている場合' do
      before { login }

      context '入力値がない場合' do
        it_behaves_like 'エンドポイントに必須のパラメータを渡さなかった場合', 'user'
      end

      context '正しい入力値の場合' do
        let(:params) { valid_params }

        it { is_expected.to eq 200 }

        it 'ユーザー情報が修正されること', autodoc: true do
          subject
          expect(json).to match(registrant_structure)
        end
      end

      context '不正な入力値の場合' do
        let(:params) { invalid_params }

        it_behaves_like '入力内容をチェックされるエンドポイントで不正な値を入力した場合'
      end
    end
  end

  describe 'DELETE /api/users/registrations' do
    subject { delete '/api/users/registrations', params: {}, headers: headers }

    context 'ログインしていない場合' do
      it { is_expected.to eq 401 }
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
