namespace :points do
  desc '期限が切れたユーザーのポイントに対して失効履歴を追加する'
  task outdate: :environment do
    now = Time.zone.now.beginning_of_day # 期限切れ日時
    target_user_ids = BatchSchedule::PointExpiration.run_before(now).pluck(:user_id)

    User.where(id: target_user_ids).find_each { |user| user.outdate_points!(now) }
  end

  desc 'notify point expiration'
  task notify: :environment do
  end
end
