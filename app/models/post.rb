# == Schema Information
#
# Table name: posts
#
#  id           :bigint(8)        not null, primary key
#  user_id(投稿者) :bigint(8)
#  title(タイトル)  :string           not null
#  body(本文)     :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class Post < ApplicationRecord
  belongs_to :user

  validates  :title, :body, presence: true
end
