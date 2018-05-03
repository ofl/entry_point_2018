# == Schema Information
#
# Table name: batch_schedule_point_expirations
#
#  id                        :bigint(8)        not null, primary key
#  user_id                   :bigint(8)
#  run_at(バッチ実施日時(ポイント失効日時)) :datetime         not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# Indexes
#
#  index_batch_schedule_point_expirations_on_run_at   (run_at)
#  index_batch_schedule_point_expirations_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

# ポイント失効バッチのスケジュール用モデル。バッチ実行後は削除される。
class BatchSchedule::PointExpiration < ApplicationRecord
  belongs_to :user

  scope :run_before, ->(now = Time.zone.now) { where('run_at <= ?', now) }

  validates :user, :run_at, presence: true
end
