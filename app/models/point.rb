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

class Point < ApplicationRecord
  belongs_to :user

  enum status: {
    got: 1, # 獲得(+)
    used: 11, # 使用(-)
    expired: 99 # 失効(-)
  }

  validates :status, presence: true, inclusion: { in: statuses }
  validates :amount, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 9999 },
                     if: :positive_points?
  validates :amount, presence: true, numericality: { only_integer: true, greater_than: -9999, less_than: 0 },
                     if: :negative_points?

  private

  def positive_points?
    got?
  end

  def negative_points?
    used? || expired?
  end
end
