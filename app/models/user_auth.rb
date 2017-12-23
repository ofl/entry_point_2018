# == Schema Information
#
# Table name: user_auths
#
#  id                   :integer          not null, primary key
#  user_id              :integer          not null
#  provider             :integer          default(0), not null
#  uid                  :string           not null
#  access_token         :string
#  access_secret        :string
#  confirmation_token   :string
#  confirmed_at         :datetime
#  confirmation_sent_at :datetime
#
# Indexes
#
#  index_user_auths_on_confirmation_token  (confirmation_token) UNIQUE
#  index_user_auths_on_provider_and_uid    (provider,uid) UNIQUE
#  index_user_auths_on_user_id             (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class UserAuth < ApplicationRecord
  belongs_to :user
end
