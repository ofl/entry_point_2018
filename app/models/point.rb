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

class Point < ApplicationRecord
  belongs_to :user

  paginates_per 10

  enum status: {
    got: 1, # 獲得(+)
    login_bonus: 2, # ログインボーナスで獲得(+)
    used: 21, # 使用(-)
    outdated: 98, # 期限切れによる失効(-)
    withdrawaled: 99 # 退会による失効(-)
  }

  POSITIVE_STATUSES = %i[got login_bonus].freeze
  NEGATIVE_STATUSES = %i[used outdated withdrawaled].freeze
  EXPIRATION_INTERVAL = Settings.models.point.expiration_interval

  validates :status, inclusion: { in: statuses }
  validates :amount, numericality: { only_integer: true, greater_than: 0, less_than: 9999 }, if: :positive?
  validates :amount, numericality: { only_integer: true, greater_than: -9999, less_than: 0 }, if: :negative?

  scope :positive, -> { where(status: POSITIVE_STATUSES) }
  scope :negative, -> { where(status: NEGATIVE_STATUSES) }

  scope :created_before, ->(at = Time.zone.now) { where('points.created_at < ?', at) }
  # statusのoutdatedとかぶるためoutdated -> is_outdated
  scope :is_outdated, ->(at = Time.zone.now) { created_before(at.beginning_of_day - EXPIRATION_INTERVAL.days) }

  # 失効日時。作成日時から失効日数経過した日の1日の終わりの日時
  def outdate_at
    return nil unless positive?
    (created_at + EXPIRATION_INTERVAL.days).end_of_day
  end

  def expired?(now = Time.zone.now)
    positive? && outdate_at < now
  end

  private

  def positive?
    POSITIVE_STATUSES.include?(status.to_sym)
  end

  def negative?
    NEGATIVE_STATUSES.include?(status.to_sym)
  end
end
