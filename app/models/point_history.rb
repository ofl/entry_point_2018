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

class PointHistory < ApplicationRecord
  belongs_to :user

  paginates_per 10

  enum operation_type: {
    got: 1, # 獲得(+)
    login_bonus: 2, # ログインボーナスで獲得(+)
    used: 21, # 使用(-)
    outdated: 98, # 期限切れによる失効(-)
    withdrawaled: 99 # 退会による失効(-)
  }

  POSITIVE_OPERATION = %i[got login_bonus].freeze
  NEGATIVE_OPERATION = %i[used outdated withdrawaled].freeze
  EXPIRATION_INTERVAL = Settings.models.point.expiration_interval

  validates :operation_type, inclusion: { in: operation_types }
  validates :amount, numericality: { only_integer: true, greater_than: 0, less_than: 9999 }, if: :positive?
  validates :amount, numericality: { only_integer: true, greater_than: -9999, less_than: 0 }, if: :negative?
  validates :total, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :version, uniqueness: { scope: :user_id }

  scope :positive, -> { where(operation_type: POSITIVE_OPERATION) }
  scope :negative, -> { where(operation_type: NEGATIVE_OPERATION) }

  scope :created_before, ->(at = Time.zone.now) { where('point_histories.created_at < ?', at) }
  # operation_typeのoutdatedとかぶるためoutdated -> is_outdated
  scope :is_outdated, ->(at = Time.zone.now) { created_before(at.beginning_of_day - EXPIRATION_INTERVAL.days) }

  before_validation :set_total_and_version

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
    POSITIVE_OPERATION.include?(operation_type.to_sym)
  end

  def negative?
    NEGATIVE_OPERATION.include?(operation_type.to_sym)
  end

  def set_total_and_version
    last_user_point_history = self.class.where(user: user).order(version: :desc).take
    self.total = (last_user_point_history&.total || 0) + amount
    self.version = (last_user_point_history&.version || 0) + 1
  end
end
