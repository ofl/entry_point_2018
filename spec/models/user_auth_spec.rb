# == Schema Information
#
# Table name: user_auths
#
#  id                   :bigint(8)        not null, primary key
#  user_id              :bigint(8)
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
  describe 'relation' do
    it 'Userに所属すること' do skip end
  end

  describe 'scope' do
    describe '.confirmed' do
      subject { UserAuth.confirmed }

      context '認証済みが存在しない場合' do
        before { create :user_auth }

        it '空であること' do is_expected.to be_blank end
      end

      context '認証済みが存在する場合' do
        let!(:user_auth) { create :user_auth, confirmed_at: Time.current }

        it '認証済みのものを含むこと' do is_expected.to contain_exactly user_auth end
      end
    end
  end

  describe 'methods' do
    describe '#confirme!' do
      subject { user_auth.confirme!(now: '2017-07-07 07:07'.in_time_zone) }

      let(:user_auth) { build :user_auth, user: user }
      let(:user) { create :user }

      context '古い本人確認が存在しない場合' do
        it 'confirmation_tokenが新しい値になること' do
          expect { subject }.to change(user_auth, :confirmation_token).from(nil).to(String)
        end

        it 'confirmed_atが現在時刻に設定されること' do
          subject
          expect(user_auth.confirmed_at).to eq '2017-07-07 07:07'.in_time_zone
        end
      end

      context '古い本人確認が存在する場合' do
        let!(:old_auth) { create :user_auth, user: user, confirmed_at: '2017-06-06 06:06'.in_time_zone }

        it 'confirmed_atが現在時刻に設定されること' do
          subject
          expect(user_auth.confirmed_at).to eq '2017-07-07 07:07'.in_time_zone
        end

        it '古い本人確認のconfirmed_atがnilになること' do
          subject
          expect(old_auth.reload.confirmed_at).to be_nil
        end
      end
    end

    describe '#confirmed?' do
      subject { user_auth.confirmed? }

      let(:user_auth) { build :user_auth }

      context 'confirmed_atがnilの場合' do
        it '偽であること' do is_expected.to be_falsey end
      end

      context 'confirmed_atがnilでない場合' do
        before { user_auth.confirmed_at = Time.current }

        it '真であること' do is_expected.to be_truthy end
      end
    end

    describe '#verified_by_auth_provider?' do
      include AuthTokenSpecHelper

      subject { user_auth.verified_by_auth_provider?(params) }

      let(:user_auth) { build :user_auth, uid: uid }
      let(:uid) { 'foobarbaz' }

      context 'プロバイダーが存在しない場合' do
        let(:params) { { provider: 'instagram' } }

        it '偽であること' do is_expected.to be_falsey end
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

    describe '#confirm_by_token!' do
      subject { user_auth.confirm_by_token!(now: at) }

      let(:user_auth) { build :user_auth, confirmation_sent_at: '2017-06-06 06:06'.in_time_zone }

      context '時間内に確認した場合' do
        let(:at) { '2017-06-06 06:07'.in_time_zone }

        it 'confirmed_atがnilでなくなること' do
          expect { subject }.to change(user_auth, :confirmed_at).from(nil).to(Time)
        end
      end

      context '時間切れだった場合' do
        let(:at) { '2017-06-07 06:07'.in_time_zone }

        it 'ConfirmationExpiredエラーが発生すること' do
          expect { subject }.to raise_error UserAuth::ConfirmationExpired
        end
      end
    end

    describe '#generate_confirmation_token' do
      subject { user_auth.generate_confirmation_token }

      let(:user_auth) { build :user_auth, confirmation_sent_at: '2017-06-06 06:06'.in_time_zone }

      it 'confirmation_tokenに値が入力されること' do
        expect { subject }.to change(user_auth, :confirmation_token).from(nil).to(String)
      end
    end

    describe '#generate_temporary_uid' do
      subject { user_auth.generate_temporary_uid }

      let(:user_auth) { build :user_auth, uid: nil, confirmation_sent_at: '2017-06-06 06:06'.in_time_zone }

      it 'uidに値が入力されること' do
        expect { subject }.to change(user_auth, :uid).from(nil).to(String)
      end
    end

    describe '#external_auth_provider?' do
      subject { user_auth.external_auth_provider? }

      let(:user_auth) { build :user_auth, provider: provider }

      context '本人確認手段がemailの場合' do
        let(:provider) { :email }

        it '偽であること' do is_expected.to be_falsey end
      end

      context '本人確認手段がtwitterの場合' do
        let(:provider) { :twitter }

        it '真であること' do is_expected.to be_truthy end
      end
    end
  end
end
