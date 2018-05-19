# == Schema Information
#
# Table name: users
#
#  id                       :bigint(8)        not null, primary key
#  email                    :string(255)      not null
#  encrypted_password       :string(255)      not null
#  username                 :string(15)       not null
#  reset_password_token     :string
#  reset_password_sent_at   :datetime
#  remember_created_at      :datetime
#  sign_in_count            :integer          default(0), not null
#  current_sign_in_at       :datetime
#  last_sign_in_at          :datetime
#  current_sign_in_ip       :inet
#  last_sign_in_ip          :inet
#  failed_attempts          :integer          default(0), not null
#  unlock_token             :string
#  locked_at                :datetime
#  authentication_token     :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  avatar_data(アバター画像)      :string
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
    it '複数のUserAuth所有できること' do skip end
  end

  describe 'methods' do
    describe '#destroy' do
      subject { user.destroy }

      before do
        create :user_auth, user: user
        create :point_history, :got, user: user, amount: 100
      end

      it 'ユーザーの本人確認は削除されること' do
        expect { subject }.to change(UserAuth.where(user_id: user.id), :count).by(-1)
      end

      it 'ユーザーのポイント数は0になること' do
        expect(PointHistory.where(user_id: user.id).sum(:amount)).to eq 100
        subject
        expect(PointHistory.where(user_id: user.id).sum(:amount)).to eq 0
      end

      it 'ポイント履歴は削除されないこと' do
        subject
        expect(PointHistory.where(user_id: user.id).count).to eq 2
      end
    end

    describe '#confirmed?' do
      subject { user.confirmed? }

      context '本人確認が存在しない場合' do
        it '偽であること' do is_expected.to be_falsey end
      end

      context '本人確認が存在する場合' do
        context '本人確認済みでない場合' do
          before { create :user_auth, user: user }
          it '偽であること' do is_expected.to be_falsey end
        end

        context '本人確認済みの場合' do
          before { create :user_auth, user: user, confirmed_at: 1.minute.ago }
          it '真であること' do is_expected.to be_truthy end
        end
      end
    end

    describe '#confirmed_by?' do
      subject { user.confirmed_by?(provider) }
      let(:provider) { :facebook }

      context '本人確認が存在しない場合' do
        it '偽であること' do is_expected.to be_falsey end
      end

      context '本人確認が存在する場合' do
        context '本人確認済みでない場合' do
          before { create :user_auth, user: user, provider: :facebook }
          it '偽であること' do is_expected.to be_falsey end
        end

        context '本人確認済みの場合' do
          before { create :user_auth, user: user, provider: :facebook, confirmed_at: 1.minute.ago }
          it '真であること' do is_expected.to be_truthy end
        end
      end
    end

    describe '#raw_reset_password_token' do
      subject { user.raw_reset_password_token }

      context '登録済みの場合' do
        it 'reset_password_tokenが入力されること' do
          expect(user.reset_password_token).to be_nil

          subject

          expect(user.reset_password_token).not_to be_nil
        end
      end
    end

    describe '#update_authentication_token!' do
      subject { user.update_authentication_token! }

      it 'authentication_tokenが入力されること' do
        before_token = user.authentication_token

        subject

        user.reload

        expect(user.authentication_token).not_to eq before_token
        expect(user.authentication_token).to start_with user.id.to_s
      end
    end

    describe '#reset_authentication_token!' do
      subject { user.reset_authentication_token! }

      it 'authentication_tokenにダミーの値が入力されること' do
        before_token = user.authentication_token

        subject

        user.reload

        expect(user.authentication_token).not_to eq before_token
        expect(user.authentication_token).not_to start_with user.id.to_s
      end
    end

    describe '#point_amount' do
      subject { user.point_amount }

      let!(:got_point_1) { create :point_history, :got, user: user, amount: 100, created_at: '2018-1-1 12:10:10'.in_time_zone }
      let!(:got_point_2) { create :point_history, :got, user: user, amount: 150, created_at: '2018-2-1 12:10:10'.in_time_zone }
      let!(:used_point) { create :point_history, :used, user: user, amount: -200, created_at: '2018-3-1 12:10:10'.in_time_zone }
      let!(:got_point_3) { create :point_history, :got, user: user, amount: 170, created_at: '2018-4-1 12:10:10'.in_time_zone }
      let!(:outdated_point) do
        create :point_history, :outdated, user: user, amount: -50, created_at: '2018-5-1 12:10:10'.in_time_zone
      end

      it 'ポイントの合計が返ること' do is_expected.to eq 170 end
    end

    describe '#get_point!' do
      let(:amount) { 150 }
      subject { user.get_point!(amount) }

      context '保存が成功した場合' do
        it 'ユーザーが所有するポイントが増えること' do
          expect { subject }.to change(PointHistory.got, :count).by(1)
          expect(PointHistory.last.amount).to eq(150)
        end
        it 'BatchSchedule::PointExpirationが増加すること' do
          expect { subject }.to change(BatchSchedule::PointExpiration, :count).by(1)
        end
      end

      context '保存に失敗した場合' do
        let(:amount) { -150 }

        it 'ActiveRecord::RecordInvalidエラーが発生すること' do
          expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end

    describe '#outdate_points!' do
      shared_examples 'バッチスケジュールが削除される' do
        it 'BatchSchedule::PointExpirationが減少すること' do
          expect { subject }.to change(BatchSchedule::PointExpiration, :count).by(-1)
        end
      end

      subject { user.outdate_points!(at) }

      let!(:got_point_1) { create :point_history, :got, user: user, amount: 100, created_at: '2018-1-1 12:10:10'.in_time_zone }
      let!(:got_point_2) { create :point_history, :got, user: user, amount: 150, created_at: '2018-2-1 12:10:10'.in_time_zone }
      let!(:used_point) { create :point_history, :used, user: user, amount: -200, created_at: '2018-3-1 12:10:10'.in_time_zone }
      let!(:got_point_3) { create :point_history, :got, user: user, amount: 170, created_at: '2018-4-1 12:10:10'.in_time_zone }

      let!(:batch_schedule) { create :batch_schedule_point_expiration, user: user, run_at: at - 1.second }

      context '2018-3-2 12:10:10に実行した場合' do
        let(:at) { '2018-3-2 12:10:10'.in_time_zone }

        it '期限切れのポイント数は変わらないこと' do
          expect { subject }.not_to change(PointHistory.outdated, :count)
        end
        it 'BatchSchedule::PointExpirationが減少すること' do
          expect { subject }.to change(BatchSchedule::PointExpiration, :count).by(-1)
        end
      end

      context '2018-4-2 12:10:10に実行した場合' do
        let(:at) { '2018-4-2 12:10:10'.in_time_zone }

        it '期限切れのポイント履歴は増えないこと' do
          expect { subject }.not_to change(PointHistory.outdated, :count) # 獲得ポイント < 使用ポイントのため
        end
        it_behaves_like 'バッチスケジュールが削除される'
      end

      context '2018-5-3 12:10:10に実行した場合' do
        let(:at) { '2018-5-3 12:10:10'.in_time_zone }

        it '期限切れのポイント履歴が増えること' do
          expect { subject }.to change(PointHistory.outdated, :count).by(1) # 250 - 200
          expect(PointHistory.last.amount).to eq(-50)
        end
        it_behaves_like 'バッチスケジュールが削除される'
      end

      context '2018-7-4 12:10:10に実行した場合' do
        let(:at) { '2018-7-4 12:10:10'.in_time_zone }

        it '期限切れのポイント履歴が増えること' do
          expect { subject }.to change(PointHistory.outdated, :count).by(1) # 獲得ポイント < 使用ポイントのため
          expect(PointHistory.last.amount).to eq(-220) # 420 - 200
        end
        it_behaves_like 'バッチスケジュールが削除される'
      end

      context '保存に失敗した場合' do
        let(:at) { '2018-7-4 12:10:10'.in_time_zone }
        before { allow_any_instance_of(User).to receive(:outdated_point_amount).and_return(-150) }

        it 'ActiveRecord::RecordInvalidエラーが発生すること' do
          expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end

    describe '#outdate_all_points!' do
      subject { user.outdate_all_points! }

      let!(:got_point_1) { create :point_history, :got, user: user, amount: 100, created_at: '2018-1-1 12:10:10'.in_time_zone }
      let!(:got_point_2) { create :point_history, :got, user: user, amount: 150, created_at: '2018-2-1 12:10:10'.in_time_zone }
      let!(:used_point) { create :point_history, :used, user: user, amount: -200, created_at: '2018-3-1 12:10:10'.in_time_zone }
      let!(:got_point_3) { create :point_history, :got, user: user, amount: 170, created_at: '2018-4-1 12:10:10'.in_time_zone }

      context '保存に成功した場合' do
        it '負のポイント履歴が作成されること' do
          expect { subject }.to change(PointHistory.withdrawaled, :count).by(1)
          expect(PointHistory.last.amount).to eq(-220) # 420 - 200
        end
      end

      context '保存に失敗した場合' do
        before { allow_any_instance_of(User).to receive(:point_amount).and_return(-150) }

        it 'ActiveRecord::RecordInvalidエラーが発生すること' do
          expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end

    describe '#outdated_point_amount' do
      subject { user.send :outdated_point_amount, at }

      let!(:got_point_1) { create :point_history, :got, user: user, amount: 100, created_at: '2018-1-1 12:10:10'.in_time_zone }
      let!(:got_point_2) { create :point_history, :got, user: user, amount: 150, created_at: '2018-2-1 12:10:10'.in_time_zone }
      let!(:used_point) do
        create :point_history, :used, user: user, amount: used_amount, created_at: '2018-3-1 12:10:10'.in_time_zone
      end
      let(:used_amount) { -50 }

      context '2018-3-2 12:10:10に実行した場合' do
        let(:at) { '2018-3-2 12:10:10'.in_time_zone }

        it '期限切れのポイント数は0であること' do is_expected.to eq 0 end
      end

      context '2018-4-2 12:10:10に実行した場合' do
        let(:at) { '2018-4-2 12:10:10'.in_time_zone }

        context '使用量が50の場合' do
          it '期限切れのポイント数は50であること' do is_expected.to eq 50 end # 100 - 50
        end

        context '使用量が200の場合' do
          let(:used_amount) { -200 }

          it '期限切れのポイント数は0であること' do is_expected.to eq 0 end # 100 - 200 < 0
        end
      end

      context '2018-5-4 12:10:10に実行した場合' do
        let(:at) { '2018-5-4 12:10:10'.in_time_zone }
        let(:used_amount) { -200 }

        context 'outdated point 存在しない場合' do
          it '期限切れのポイント数は50であること' do is_expected.to eq 50 end # 100 + 150 - 200 > 0
        end

        context 'outdated point is 存在する場合' do
          before { create :point_history, :outdated, user: user, amount: -50 }

          it '期限切れのポイント数は0であること' do
            is_expected.to eq 0 # 100 + 150 - 200 - 50 == 0
          end
        end
      end
    end
  end
end
