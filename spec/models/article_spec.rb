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

require 'rails_helper'

RSpec.describe Article, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
