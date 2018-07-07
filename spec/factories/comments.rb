# == Schema Information
#
# Table name: comments
#
#  id           :bigint(8)        not null, primary key
#  user_id(投稿者) :bigint(8)
#  post_id(投稿)  :bigint(8)
#  body(本文)     :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_comments_on_post_id  (post_id)
#  index_comments_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :comment do
    user
    post
    body { Faker::Lorem.paragraph }
  end
end
