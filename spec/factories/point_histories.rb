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

FactoryBot.define do
  factory :point_history do
    user
    operation_type { PointHistory.operation_types.keys.sample }
    sequence(:version) { |n| n }
    total 100

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
      created_at { (PointHistory::EXPIRATION_INTERVAL + 1).days.ago }
    end
  end
end
