# == Schema Information
#
# Table name: points
#
#  id                   :bigint(8)        not null, primary key
#  user_id              :bigint(8)
#  status(状態(獲得/使用/失効)) :integer          not null
#  amount(ポイント数)        :integer          default(0), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_points_on_user_id  (user_id)
#

FactoryBot.define do
  factory :point do
    user
    status { Point.statuses.keys.sample }

    trait :got do
      status :got
      amount { rand(1..20) }
    end

    trait :used do
      status :used
      amount { -rand(1..10) }
    end

    trait :outdated do
      status :outdated
      amount { -rand(1..10) }
      created_at { (Point::EXPIRATION_INTERVAL + 1).days.ago }
    end
  end
end
