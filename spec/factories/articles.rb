# == Schema Information
#
# Table name: articles
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)
#  title      :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
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
    user nil
    sequence(:title) { |n| "title_#{n}" }
    sequence(:body) { |n| "body_#{n}" }
  end
end
