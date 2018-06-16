module PointAvailable
  extend ActiveSupport::Concern

  included do
    has_many :point_histories # rubocop:disable Rails/HasManyOrHasOneDependent
    has_many :point_expiration_schedules, class_name: 'BatchSchedule::PointExpiration',
                                          dependent: :destroy, inverse_of: :user
    has_one :last_point_history, lambda {
      order(version: :desc)
    }, class_name: :PointHistory, inverse_of: :user
  end

  # 所持しているポイント
  def point_amount
    last_point_history&.total || 0
  end

  # ポイントの獲得。獲得したポイントは期限がくれば失効するように失効バッチスケジュールを登録する
  def get_point!(amount, operation_type = :got)
    transaction do
      point = point_histories.create!(operation_type: operation_type, amount: amount)
      point_expiration_schedules.create!(run_at: point.outdate_at) # 失効バッチスケジュールの登録
    end
  end

  # ポイントの喪失
  def lose_point!(amount, operation_type = :used)
    point_histories.create!(operation_type: operation_type, amount: -amount)
  end

  # 期限切れのポイントを失効させる
  def outdate_points!(now = Time.zone.now)
    outdated_points = point_histories.positive.is_outdated(now)

    transaction do
      point_expiration_schedules.run_before(now).delete_all # now以前の失効バッチスケジュールを削除
      return if outdated_points.blank?

      amount = outdated_point_amount(now) # 失効するポイント数
      lose_point!(amount, :outdated) unless amount.zero? # 失効履歴の作成
    end
  end

  # 手持ちのポイント全てを失効させる(退会時など)
  def outdate_all_points!(operation_type = :withdrawaled)
    outdated_points = point_amount

    lose_point!(outdated_points, operation_type) unless outdated_points.zero? # 失効履歴の作成
  end

  private

  # 失効するポイント数
  def outdated_point_amount(now = Time.zone.now)
    outdated_amount = point_histories.positive.is_outdated(now).sum(:amount) # 失効以前に獲得したポイント
    used_amount = point_histories.negative.created_before(now).sum(:amount) # 現在までに使用（失効）したポイント(マイナス値)

    # 失効以前に獲得したポイントから現在までに使用したポイントを引いたものを0と比較し、多い方を返す
    [outdated_amount - used_amount.abs, 0].max
  end
end
