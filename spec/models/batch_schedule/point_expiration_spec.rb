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

require 'rails_helper'

RSpec.describe BatchSchedule::PointExpiration, type: :model do
  describe 'relation' do
    it 'Userに所属すること' do skip end
  end
end
