module PointAvailable
  extend ActiveSupport::Concern

  def point_amount
    points.sum(:amount)
  end

  def get_point!(amount)
    transaction do
      point = points.create!(status: :got, amount: amount)
      point_expiration_schedules.create!(batch_at: point.expire_at) # 失効バッチスケジュールの登録
    end
  end

  # 期限切れのポイントの失効処理
  def expire_points!(now = Time.zone.now)
    expire_points = points.positive.is_expired(now)

    transaction do
      point_expiration_schedules.batch_at_before(now).delete_all # now以前の失効バッチスケジュールを削除
      return if expire_points.blank?

      amount = expired_point_amount(now) # 失効するポイント数
      points.create!(status: :expired, amount: -amount) unless amount.zero? # 失効履歴の作成
    end
  end

  private

  # 失効するポイント数
  def expired_point_amount(now = Time.zone.now)
    expired_amount = points.positive.is_expired(now).sum(:amount) # 失効以前に獲得ポイント
    used_amount = points.negative.created_before(now).sum(:amount) # 現在までに使用（失効）したポイント(マイナス値)

    # 失効以前に獲得したポイントから現在までに使用したポイントを引いたものを0と比較し、多い方を返す
    [expired_amount - used_amount.abs, 0].max
  end
end
