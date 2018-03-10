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

  POSITIVE_STATUSES = %i[got].freeze
  NEGATIVE_STATUSES = %i[used expired].freeze
  EXPIRATION_INTERVAL = Settings.models.point.expiration_interval

  validates :status, presence: true, inclusion: { in: statuses }
  validates :amount, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 9999 },
                     if: :positive?
  validates :amount, presence: true, numericality: { only_integer: true, greater_than: -9999, less_than: 0 },
                     if: :negative?

  scope :positive, -> { where(status: POSITIVE_STATUSES) }
  scope :negative, -> { where(status: NEGATIVE_STATUSES) }

  scope :created_before, ->(at = Time.zone.now) { where('points.created_at < ?', at) }
  # statusのexpiredとかぶるためexpired -> is_expired
  scope :is_expired, ->(at = Time.zone.now) { created_before(at - EXPIRATION_INTERVAL.days) }

  def expire_at
    created_at + EXPIRATION_INTERVAL.days
  end

  private

  def positive?
    POSITIVE_STATUSES.include?(status.to_sym)
  end

  def negative?
    NEGATIVE_STATUSES.include?(status.to_sym)
  end
end
