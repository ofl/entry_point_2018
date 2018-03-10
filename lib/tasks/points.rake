namespace :points do
  desc 'expire user points'
  task expire: :environment do
    now = Time.zone.now.beginning_of_day # 期限切れ日時

    User.find_each { |user| user.expire_points!(now) }
  end

  desc 'notify point expiration'
  task notify: :environment do
  end
end
