namespace :points do
  desc 'expire user points'
  task expire: :environment do
    at = Time.zone.now.beginning_of_day # 期限切れ日時

    User.has_expired_points(at).find_each { |user| user.expire_points!(at) }
  end

  desc 'notify point expiration'
  task notify: :environment do
  end
end
