# == Schema Information
#
# Table name: users
#
#  id                       :bigint(8)        not null, primary key
#  email                    :string(255)      not null
#  encrypted_password       :string(255)      not null
#  username                 :string(15)       not null
#  reset_password_token     :string
#  reset_password_sent_at   :datetime
#  remember_created_at      :datetime
#  sign_in_count            :integer          default(0), not null
#  current_sign_in_at       :datetime
#  last_sign_in_at          :datetime
#  current_sign_in_ip       :inet
#  last_sign_in_ip          :inet
#  failed_attempts          :integer          default(0), not null
#  unlock_token             :string
#  locked_at                :datetime
#  authentication_token     :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  avatar_data(アバター画像)      :string
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#

FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user_#{n}" }
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { 'password' }
    authentication_token { Devise.friendly_token }

    trait :confirmed do
      after(:build) do |user|
        user.user_auths << FactoryBot.build(
          :user_auth, provider: :twitter, confirmed_at: 1.minute.ago
        )
      end
    end

    trait :with_avatar do
      image { File.open(Rails.root.join('spec', 'fixtures', 'files', 'youngman_31.png')) }
    end
  end
end
