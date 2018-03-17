module PointAvailable
  extend ActiveSupport::Concern

  # 所持しているポイント
  def point_amount
    points.sum(:amount)
  end

  # ポイントの獲得。獲得したポイントは期限がくれば失効する
  def get_point!(amount, status = :got)
    transaction do
      point = points.create!(status: status, amount: amount)
      point_expiration_schedules.create!(run_on: point.outdate_at) # 失効バッチスケジュールの登録
    end
  end

  # ポイントの喪失
  def lose_point!(amount, status = :used)
    points.create!(status: status, amount: -amount)
  end

  # 期限切れのポイントを失効させる
  def outdate_points!(now = Time.zone.now)
    outdated_points = points.positive.is_outdated(now)

    transaction do
      point_expiration_schedules.run_on_before(now).delete_all # now以前の失効バッチスケジュールを削除
      return if outdated_points.blank?

      amount = outdated_point_amount(now) # 失効するポイント数
      lose_point!(amount, :outdated) unless amount.zero? # 失効履歴の作成
    end
  end

  # 手持ちのポイント全てを失効させる(退会時など)
  def outdate_all_points!(status = :withdrawaled)
    outdated_points = point_amount

    lose_point!(outdated_points, status) unless outdated_points.zero? # 失効履歴の作成
  end

  private

  # 失効するポイント数
  def outdated_point_amount(now = Time.zone.now)
    outdated_amount = points.positive.is_outdated(now).sum(:amount) # 失効以前に獲得したポイント
    used_amount = points.negative.created_before(now).sum(:amount) # 現在までに使用（失効）したポイント(マイナス値)

    # 失効以前に獲得したポイントから現在までに使用したポイントを引いたものを0と比較し、多い方を返す
    [outdated_amount - used_amount.abs, 0].max
  end
end
