# == Schema Information
#
# Table name: point_histories
#
#  id                               :bigint(8)        not null, primary key
#  user_id                          :bigint(8)
#  operation_type((0:獲得,1:使用,2:失効)) :integer          not null
#  amount(増減したポイント数)                :integer          default(0), not null
#  total(総ポイント数)                    :integer          default(0), not null
#  version(衝突防止のためのバージョン)           :integer          default(0), not null
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#
# Indexes
#
#  index_point_histories_on_user_id              (user_id)
#  index_point_histories_on_user_id_and_version  (user_id,version DESC)
#

require 'rails_helper'

RSpec.describe PointHistory, type: :model do
  let!(:user) { create :user }
  let!(:default_point) { create :point_history, :got, user: user, amount: 1000 }

  describe 'scope' do
    let!(:got_point) { create :point_history, :got, user: user, created_at: created_at }
    let!(:used_point) { create :point_history, :used, user: user, created_at: created_at }
    let!(:outdated_point) { create :point_history, :outdated, user: user, created_at: created_at }
    let(:created_at) { '2018-1-1 12:13:23'.in_time_zone }

    describe '.positive' do
      subject { PointHistory.positive }

      it '正のポイントが含まれること' do is_expected.to contain_exactly(got_point, default_point) end
    end

    describe '.negative' do
      subject { PointHistory.negative }

      it '負のポイントが含まれること' do is_expected.to contain_exactly(used_point, outdated_point) end
    end

    describe '.is_outdated' do
      before { Timecop.freeze(now) }
      after { Timecop.return }

      subject { PointHistory.is_outdated }

      context '期限が来てない場合' do
        let(:now) { '2018-4-1'.in_time_zone.end_of_day }

        it '該当数は0であること' do expect(subject.count).to eq 0 end
      end

      context '期限が来た場合' do
        let(:now) { '2018-4-2'.in_time_zone.beginning_of_day }

        it '該当数は0でないこと' do expect(subject.count).to eq 3 end
      end
    end
  end

  describe 'validation' do
    subject { point.valid? }

    context 'カテゴリーが獲得でポイント数が正の場合' do
      let(:point) { build :point_history, :got, user: user, amount: 100 }

      it '真であること' do is_expected.to be_truthy end
    end

    context 'カテゴリーが獲得でポイント数が負の場合' do
      let(:point) { build :point_history, :got, user: user, amount: -100 }

      it '偽であること' do is_expected.to be_falsey end
    end

    context 'カテゴリーが使用でポイント数が正の場合' do
      let(:point) { build :point_history, :used, user: user, amount: 100 }

      it '偽であること' do is_expected.to be_falsey end
    end

    context 'カテゴリーが使用でポイント数が負の場合' do
      let(:point) { build :point_history, :used, user: user, amount: -100 }

      it '真であること' do is_expected.to be_truthy end
    end
  end

  describe '#outdate_at' do
    before { Timecop.freeze(now) }
    after { Timecop.return }

    let(:now) { '2018-1-1 12:13:23'.in_time_zone }

    subject { point.outdate_at }

    context '負のポイントの場合' do
      before { create :point_history, :got, user: user, amount: 100 }
      let(:point) { create :point_history, :used, user: user }

      it 'nilであること' do is_expected.to be_nil end
    end

    context '正のポイントの場合' do
      let(:point) { create :point_history, :got, user: user }

      it '3ヶ月後の日にちが返ること' do is_expected.to eq '2018-4-1'.in_time_zone.end_of_day end
    end
  end

  describe '#expired?' do
    before { Timecop.freeze(now) }
    after { Timecop.return }

    let(:created_at) { '2018-1-1 12:13:23'.in_time_zone }
    let(:now) { '2018-4-1'.in_time_zone.end_of_day }

    subject { point.expired? }

    context '負のポイントの場合' do
      let(:point) { create :point_history, :used, user: user, created_at: created_at }

      it '偽であること' do is_expected.to be_falsey end
    end

    context '正のポイントの場合' do
      let(:point) { create :point_history, :got, user: user, created_at: created_at }

      context '期限切れでない場合' do
        it '偽であること' do is_expected.to be_falsey end
      end

      context '期限切れの場合' do
        let(:now) { '2018-4-2'.in_time_zone.beginning_of_day }

        it '真であること' do is_expected.to be_truthy end
      end
    end
  end
end
