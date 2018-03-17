# == Schema Information
#
# Table name: batch_schedule_point_expirations
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  run_on     :date             not null              # バッチ実施日(ポイント失効日)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_batch_schedule_point_expirations_on_run_on   (run_on)
#  index_batch_schedule_point_expirations_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :batch_schedule_point_expiration, class: 'BatchSchedule::PointExpiration' do
    user
    run_on '2018-03-10 10:17:52'
  end
end
