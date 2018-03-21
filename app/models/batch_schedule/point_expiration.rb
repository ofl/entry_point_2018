# == Schema Information
#
# Table name: batch_schedule_point_expirations
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  run_at     :datetime         not null              # バッチ実施日時(ポイント失効日時)
#  created_at :datetime         not null
#  updated_at :datetime         not null
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
end
