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

def create_user(username = Faker::Internet.user_name)
  user = create(:user, username: username, email: Faker::Internet.email)
  create(:user_auth, user: user, provider: :email, uid: user.email)
  user
end

users = []

unless User.exists?
  users << create_user('testuser')

  10.times do
    users << create_user
  end
end

unless PointHistory.exists?
  users.each do |user|
    operation_day = 120.days.ago
    create(:point_history, :got, amount: 100, total: 100, user: user, version: 1, created_at: operation_day)
    10.times do
      operation_day += 10.days
      point = [-15, -10, -5, 5, 10, 15].sample
      operation = point.positive? ? :got : :used

      create(:point_history, operation, amount: point, user: user, created_at: operation_day)
    end
  end
end

unless Post.exists?
  users.each do |user|
    rand(5).times do
      post = create(:post, user: user)
    end
  end
end
