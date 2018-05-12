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

FactoryBot.define do
  factory :article do
    user
    sequence(:title) { |n| "title_#{n}" }
    sequence(:body) { |n| "body_#{n}" }
    published_at nil
  end
end
