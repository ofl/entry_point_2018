# == Schema Information
#
# Table name: articles
#
#  id                 :bigint(8)        not null, primary key
#  user_id(著者)        :bigint(8)
#  title(タイトル)        :string           not null
#  body(本文)           :text             not null
#  published_at(公開日時) :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class Article < ApplicationRecord
  belongs_to :user

  validates :title, :body, presence: true
  validates :title, length: { maximum: 255 }

  attribute :name, :string
  attribute :password, :string
  attribute :prefecture, :string
  attribute :closed_at, :datetime
  attribute :count, :integer
end
