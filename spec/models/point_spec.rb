# == Schema Information
#
# Table name: points
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  status     :integer          not null              # 状態(獲得/使用/失効)
#  amount     :integer          default(0), not null  # ポイント数
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
    let!(:outdated_point) { create :point, :outdated }

    describe '.positive' do
      subject { Point.positive }

      it { is_expected.to contain_exactly(got_point) }
    end

    describe '.negative' do
      subject { Point.negative }

      it { is_expected.to contain_exactly(used_point, outdated_point) }
    end
  end

  describe 'validation' do
    subject { point.valid? }

    context 'got amount(+)' do
      let(:point) { build :point, :got, amount: 100 }

      it { is_expected.to be_truthy }
    end

    context 'got amount(-)' do
      let(:point) { build :point, :got, amount: -100 }

      it { is_expected.to be_falsey }
    end

    context 'used amount(+)' do
      let(:point) { build :point, :used, amount: 100 }

      it { is_expected.to be_falsey }
    end

    context 'used amount(-)' do
      let(:point) { build :point, :used, amount: -100 }

      it { is_expected.to be_truthy }
    end
  end
end
