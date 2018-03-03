# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      not null
#  encrypted_password     :string(255)      not null
#  username               :string(15)       not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  authentication_token   :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }

  describe 'relations' do
    it { is_expected.to have_many(:user_auths) }
  end

  describe 'methods' do
    describe '#confirmed?' do
      subject { user.confirmed? }

      context 'user_auth not exist' do
        it { is_expected.to be_falsey }
      end

      context 'exists' do
        context 'not confirmed' do
          before { create :user_auth, user: user }
          it { is_expected.to be_falsey }
        end

        context 'confirmed' do
          before { create :user_auth, user: user, confirmed_at: 1.minute.ago }
          it { is_expected.to be_truthy }
        end
      end
    end

    describe '#confirmed?' do
      subject { user.confirmed? }

      context 'not exist' do
        it { is_expected.to be_falsey }
      end

      context 'exists' do
        context 'not confirmed' do
          before { create :user_auth, user: user, provider: :facebook }
          it { is_expected.to be_falsey }
        end

        context 'confirmed' do
          before { create :user_auth, user: user, provider: :facebook, confirmed_at: 1.minute.ago }
          it { is_expected.to be_truthy }
        end
      end
    end

    describe '#confirmed_by?' do
      subject { user.confirmed_by?(provider) }
      let(:provider) { :facebook }

      context 'not exist' do
        it { is_expected.to be_falsey }
      end

      context 'exists' do
        context 'not confirmed' do
          before { create :user_auth, user: user, provider: :facebook }
          it { is_expected.to be_falsey }
        end

        context 'confirmed' do
          before { create :user_auth, user: user, provider: :facebook, confirmed_at: 1.minute.ago }
          it { is_expected.to be_truthy }
        end
      end
    end

    describe '#raw_reset_password_token' do
      subject { user.raw_reset_password_token }

      context 'registered' do
        it do
          expect(user.reset_password_token).to be_nil

          subject

          expect(user.reset_password_token).not_to be_nil
        end
      end
    end

    describe '#update_authentication_token!' do
      subject { user.update_authentication_token! }

      it do
        before_token = user.authentication_token

        subject

        user.reload

        expect(user.authentication_token).not_to eq before_token
        expect(user.authentication_token).to start_with user.id.to_s
      end
    end

    describe '#reset_authentication_token!' do
      subject { user.reset_authentication_token! }

      it do
        before_token = user.authentication_token

        subject

        user.reload

        expect(user.authentication_token).not_to eq before_token
        expect(user.authentication_token).not_to start_with user.id.to_s
      end
    end

    describe '#point_amount' do
      subject { user.point_amount }

      let!(:got_point_1) { create :point, :got, user: user, amount: 100, created_at: '2018/1/1 12:10:10'.in_time_zone }
      let!(:got_point_2) { create :point, :got, user: user, amount: 150, created_at: '2018/2/1 12:10:10'.in_time_zone }
      let!(:used_point) { create :point, :used, user: user, amount: -200, created_at: '2018/3/1 12:10:10'.in_time_zone }
      let!(:got_point_3) { create :point, :got, user: user, amount: 170, created_at: '2018/4/1 12:10:10'.in_time_zone }
      let!(:expired_point) do
        create :point, :expired, user: user, amount: -50, created_at: '2018/5/1 12:10:10'.in_time_zone
      end

      it { is_expected.to eq 170 }
    end

    describe '#expired_points!' do
      subject { user.expire_points!(at) }

      let!(:got_point_1) { create :point, :got, user: user, amount: 100, created_at: '2018/1/1 12:10:10'.in_time_zone }
      let!(:got_point_2) { create :point, :got, user: user, amount: 150, created_at: '2018/2/1 12:10:10'.in_time_zone }
      let!(:used_point) { create :point, :used, user: user, amount: -200, created_at: '2018/3/1 12:10:10'.in_time_zone }
      let!(:got_point_3) { create :point, :got, user: user, amount: 170, created_at: '2018/4/1 12:10:10'.in_time_zone }

      context 'at 2018/3/2 12:10:10' do
        let(:at) { '2018/3/2 12:10:10'.in_time_zone }

        it do
          expect { subject }.not_to change(Point, :count)
          expect(got_point_1.reload.expired_at).to be_nil
        end
      end

      context 'at 2018/4/2 12:10:10' do
        let(:at) { '2018/4/2 12:10:10'.in_time_zone }

        it do
          expect { subject }.not_to change(Point, :count) # 獲得ポイント < 使用ポイントのため
          expect(got_point_1.reload.expired_at).to eq at
        end
      end

      context 'at 2018/5/3 12:10:10' do
        let(:at) { '2018/5/3 12:10:10'.in_time_zone }

        it do
          expect { subject }.to change(Point, :count).by(1) # 250 - 200
          expect(Point.last.amount).to eq(-50)
          expect(got_point_2.reload.expired_at).to eq at
        end
      end

      context 'at 2018/7/4 12:10:10' do
        let(:at) { '2018/7/4 12:10:10'.in_time_zone }

        it do
          expect { subject }.to change(Point, :count).by(1) # 獲得ポイント < 使用ポイントのため
          expect(Point.last.amount).to eq(-220) # 420 - 200
          expect(got_point_2.reload.expired_at).to eq at
        end
      end
    end

    describe '#expired_point_amount' do
      subject { user.send :expired_point_amount, at }

      let!(:got_point_1) { create :point, :got, user: user, amount: 100, created_at: '2018/1/1 12:10:10'.in_time_zone }
      let!(:got_point_2) { create :point, :got, user: user, amount: 150, created_at: '2018/2/1 12:10:10'.in_time_zone }
      let!(:used_point) do
        create :point, :used, user: user, amount: used_amount, created_at: '2018/3/1 12:10:10'.in_time_zone
      end
      let(:used_amount) { -50 }

      context 'at 2018/3/2 12:10:10' do
        let(:at) { '2018/3/2 12:10:10'.in_time_zone }

        it { is_expected.to eq 0 }
      end

      context 'at 2018/4/2 12:10:10' do
        let(:at) { '2018/4/2 12:10:10'.in_time_zone }

        context 'used amount is 50' do
          it { is_expected.to eq 50 } # 100 - 50
        end

        context 'used amount is 200' do
          let(:used_amount) { -200 }

          it { is_expected.to eq 0 } # 100 - 50
        end
      end

      context 'at 2018/5/4 12:10:10' do
        let(:at) { '2018/5/4 12:10:10'.in_time_zone }
        let(:used_amount) { -200 }

        context 'expired point not exists' do
          it { is_expected.to eq 50 } # 100 + 150 - 200
        end

        context 'expired point is exists' do
          before { create :point, :expired, user: user, amount: -50 }

          it { is_expected.to eq 0 } # 100 + 150 - 200 - 50
        end
      end
    end
  end
end
