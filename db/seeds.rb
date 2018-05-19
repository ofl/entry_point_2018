# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# if Rails.env.development?
# end

def create(*args)
  FactoryBot.create(*args)
end

unless User.exists?
  user = create :user, username: 'testuser', email: 'test@example.com', password: 'password'
  create :user_auth, user: user, provider: :email, uid: 'test@example.com'
end

unless PointHistory.exists?
  User.all.each do |u|
    operation_day = 120.days.ago
    last_point_history = create :point_history, :got, amount: 100, total: 100, user: u, created_at: operation_day
    10.times do
      operation_day += 10.days
      point = [-15, -10, -5, 5, 10, 15].sample
      total = last_point_history.total + point
      operation = point.positive? ? :got : :used

      last_point_history = create :point_history, operation, amount: point, total: total,
                                                             user: u, created_at: operation_day
    end
  end
end
