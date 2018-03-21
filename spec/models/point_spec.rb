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
    let!(:got_point) { create :point, :got, created_at: created_at }
    let!(:used_point) { create :point, :used, created_at: created_at }
    let!(:outdated_point) { create :point, :outdated, created_at: created_at }
    let(:created_at) { '2018-1-1 12:13:23'.in_time_zone }

    describe '.positive' do
      subject { Point.positive }

      it { is_expected.to contain_exactly(got_point) }
    end

    describe '.negative' do
      subject { Point.negative }

      it { is_expected.to contain_exactly(used_point, outdated_point) }
    end

    describe '.is_outdated' do
      before { Timecop.freeze(now) }
      after { Timecop.return }

      subject { Point.is_outdated }

      context '2018-4-1' do
        let(:now) { '2018-4-1'.in_time_zone.end_of_day }

        it { expect(subject.count).to eq 0 }
      end

      context '2018-4-2' do
        let(:now) { '2018-4-2'.in_time_zone.beginning_of_day }

        it { expect(subject.count).to eq 3 }
      end
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

  describe '#outdate_at' do
    before { Timecop.freeze(now) }
    after { Timecop.return }

    let(:now) { '2018-1-1 12:13:23'.in_time_zone }

    subject { point.outdate_at }

    context 'negative point' do
      let(:point) { create :point, :used }

      it { is_expected.to be_nil }
    end

    context 'positive point' do
      let(:point) { create :point, :got }

      it { is_expected.to eq '2018-4-1'.in_time_zone.end_of_day }
    end
  end

  describe '#expired?' do
    before { Timecop.freeze(now) }
    after { Timecop.return }

    let(:created_at) { '2018-1-1 12:13:23'.in_time_zone }
    let(:now) { '2018-4-1'.in_time_zone.end_of_day }

    subject { point.expired? }

    context 'negative point' do
      let(:point) { create :point, :used, created_at: created_at }

      it { is_expected.to be_falsey }
    end

    context 'positive point' do
      let(:point) { create :point, :got, created_at: created_at }

      context '2018-4-1' do
        it { is_expected.to be_falsey }
      end

      context '2018-4-2' do
        let(:now) { '2018-4-2'.in_time_zone.beginning_of_day }

        it { is_expected.to be_truthy }
      end
    end
  end
end
