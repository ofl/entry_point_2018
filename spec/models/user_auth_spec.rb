# == Schema Information
#
# Table name: user_auths
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  provider             :integer
#  uid                  :string
#  access_token         :string
#  access_secret        :string
#  confirmation_token   :string
#  confirmed_at         :datetime
#  confirmation_sent_at :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_user_auths_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe UserAuth, type: :model do
  it { is_expected.to belong_to(:user) }

  describe 'scope' do
    describe '.confirmed' do
      subject { UserAuth.confirmed }

      context 'not exists' do
        let!(:user_auth) { create :user_auth }

        it { is_expected.to be_blank }
      end

      context 'exists' do
        let!(:user_auth) { create :user_auth, confirmed_at: Time.current }

        it { is_expected.to contain_exactly user_auth }
      end
    end
  end

  describe 'methods' do
    describe '#confirme!' do
      let(:user_auth) { build :user_auth, user: user }
      let(:user) { create :user }

      subject { user_auth.confirme!(at: Time.zone.parse('2017-07-07 07:07')) }

      context 'old auth not exists' do
        it do
          old_token = user_auth.confirmation_token

          subject
          expect(user_auth.persisted?).to be_truthy
          expect(user_auth.confirmed_at).to eq Time.zone.parse('2017-07-07 07:07')
          expect(user_auth.confirmation_token).not_to eq old_token
        end
      end

      context 'old auth exists' do
        let!(:old_auth) { create :user_auth, user: user, confirmed_at: Time.zone.parse('2017-06-06 06:06') }

        it do
          expect(old_auth.confirmed_at).to eq Time.zone.parse('2017-06-06 06:06')

          subject
          expect(user_auth.persisted?).to be_truthy
          expect(user_auth.confirmed_at).to eq Time.zone.parse('2017-07-07 07:07')

          expect(old_auth.reload.confirmed_at).to be_nil
        end
      end
    end

    describe 'confirmed?' do
      let(:user_auth) { build :user_auth }

      subject { user_auth.confirmed? }

      context 'confirmed_at nil' do
        it { is_expected.to be_falsey }
      end

      context 'confirmed_at nil' do
        before { user_auth.confirmed_at = Time.current }

        it { is_expected.to be_truthy }
      end
    end

    describe 'verified_by_auth_provider?' do
      include AuthTokenSpecHelper

      let(:user_auth) { build :user_auth, uid: uid }
      let(:uid) { 'foobarbaz' }

      subject { user_auth.verified_by_auth_provider?(params) }

      context 'client not found' do
        let(:params) { { provider: 'instagram' } }

        it { is_expected.to be_falsey }
      end

      # # circleci error
      # context 'user uid info not match' do
      #   let(:params) { { provider: 'facebook', access_token: test_fb_user[:access_token] } }
      #   let(:uid) { 'foobarbaz' }
      #
      #   it do
      #     VCR.use_cassette 'facebook_valid_credential' do
      #       is_expected.to be_falsey
      #     end
      #   end
      # end

      # context 'user uid info match' do
      #   let(:params) { { provider: 'facebook', access_token: test_fb_user[:access_token] } }
      #   let(:uid) { test_fb_user[:uid] }
      #
      #   it do
      #     VCR.use_cassette 'facebook_valid_credential' do
      #       is_expected.to be_truthy
      #     end
      #   end
      # end
    end

    describe 'confirm_by_token!' do
      let(:user_auth) { build :user_auth, confirmation_sent_at: Time.zone.parse('2017-06-06 06:06') }

      subject { user_auth.confirm_by_token!(at: at) }

      context 'token in time' do
        let(:at) { Time.zone.parse('2017-06-06 06:07') }

        it do
          expect(user_auth.confirmed_at).to be_nil

          subject

          expect(user_auth.confirmed_at).not_to be_nil
        end
      end

      context 'token expired' do
        let(:at) { Time.zone.parse('2017-06-07 06:07') }

        it { expect { subject }.to raise_error UserAuth::ConfirmationExpired }
      end
    end

    describe 'generate_confirmation_token' do
      let(:user_auth) { build :user_auth, confirmation_sent_at: Time.zone.parse('2017-06-06 06:06') }

      subject { user_auth.generate_confirmation_token }

      it do
        expect(user_auth.confirmation_token).to be_nil

        subject

        expect(user_auth.confirmation_token).not_to be_nil
      end
    end

    describe 'generate_temporary_uid' do
      let(:user_auth) { build :user_auth, uid: nil, confirmation_sent_at: Time.zone.parse('2017-06-06 06:06') }

      subject { user_auth.generate_temporary_uid }

      it do
        expect(user_auth.uid).to be_nil

        subject

        expect(user_auth.uid).not_to be_nil
      end
    end

    describe 'external_auth_provider?' do
      let(:user_auth) { build :user_auth, provider: provider }

      subject { user_auth.external_auth_provider? }

      context 'email' do
        let(:provider) { :email }

        it { is_expected.to be_falsey }
      end

      context 'twitter' do
        let(:provider) { :twitter }

        it { is_expected.to be_truthy }
      end
    end
  end
end
