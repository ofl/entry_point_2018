# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  username               :string           not null
#  encrypted_password     :string           not null
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

    describe '#email' do
      subject { user.email }

      context 'not registered' do
        it { is_expected.to be_nil }
      end

      context 'registered' do
        let!(:email_auth) do
          create :user_auth, user: user, uid: 'foo@bar.com', provider: 'email', confirmed_at: Time.current
        end

        it { is_expected.to eq email_auth.uid }
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
  end
end
