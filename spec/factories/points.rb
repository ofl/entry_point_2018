# == Schema Information
#
# Table name: points
#
#  id                               :bigint(8)        not null, primary key
#  user_id                          :bigint(8)
#  operation_type((0:獲得,1:使用,2:失効)) :integer          not null
#  amount(ポイント数)                    :integer          default(0), not null
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#
# Indexes
#
#  index_points_on_user_id  (user_id)
#

FactoryBot.define do
  factory :point do
    user
    operation_type { Point.operation_types.keys.sample }

    trait :got do
      operation_type :got
      amount { rand(1..20) }
    end

    trait :used do
      operation_type :used
      amount { -rand(1..10) }
    end

    trait :outdated do
      operation_type :outdated
      amount { -rand(1..10) }
      created_at { (Point::EXPIRATION_INTERVAL + 1).days.ago }
    end
  end
end
