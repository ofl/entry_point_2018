# == Schema Information
#
# Table name: points
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  status     :integer          not null              # 状態(獲得/使用/失効)
#  amount     :integer          default(0), not null  # ポイント数
#  expired_at :datetime                               # 獲得ポイントの失効処理日時
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_points_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe Point, type: :model do
  describe 'scope' do
    let!(:got_point) { create :point, :got }
    let!(:used_point) { create :point, :used }
    let!(:expired_point) { create :point, :expired }

    describe '.positive' do
      subject { Point.positive }

      it { is_expected.to contain_exactly(got_point) }
    end

    describe '.negative' do
      subject { Point.negative }

      it { is_expected.to contain_exactly(used_point, expired_point) }
    end
  end

  describe '#expire_at' do
    let(:point) { create :point, expired_at: expired_at, created_at: created_at }
    let(:created_at) { Time.zone.parse('2018/1/1 12:10:10') }

    subject { point.expire_at }

    context 'expired_at is nil' do
      let(:expired_at) { :nil }

      it { is_expected.to eq created_at + Point::EXPIRATION_INTERVAL.days }
    end

    context 'expired_at exists' do
      let(:expired_at) { Time.zone.parse('2018/2/2 12:10:10') }

      it { is_expected.to eq expired_at }
    end
  end
end
