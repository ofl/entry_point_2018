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

FactoryBot.define do
  factory :point do
    user
    status { Point.statuses.keys.sample }
    expired_at nil

    trait :got do
      status :got
      amount { rand(1..20) }
    end

    trait :used do
      status :used
      amount { -rand(1..10) }
    end

    trait :expired do
      status :expired
      amount { -rand(1..10) }
      expired_at Time.zone.now
    end
  end
end
