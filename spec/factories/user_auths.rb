# == Schema Information
#
# Table name: user_auths
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  provider             :integer
#  uid                  :string
#  access_token         :string
#  access_secret        :string
#  confirmation_token   :string
#  confirmed_at         :datetime
#  confirmation_sent_at :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_user_auths_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :user_auth do
    user nil
    provider 1
    uid "MyString"
    access_token "MyString"
    access_secret "MyString"
    confirmation_token "MyString"
    confirmed_at "2018-01-08 16:27:19"
    confirmation_sent_at "2018-01-08 16:27:19"
  end
end
