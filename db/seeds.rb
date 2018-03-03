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

unless Point.exists?
  User.all.each do |u|
    10.times do
      create :point, user: u, amount: rand(1..20), created_at: rand(2..20).days.ago
    end
  end
end
