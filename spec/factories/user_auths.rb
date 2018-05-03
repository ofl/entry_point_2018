# == Schema Information
#
# Table name: user_auths
#
#  id                   :bigint(8)        not null, primary key
#  user_id              :bigint(8)
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
    user
    provider { :facebook }
    uid { SecureRandom.uuid }

    factory :email_user_auth do
      provider { :email }
      uid { 'foo@example.com' }
    end
  end
end
