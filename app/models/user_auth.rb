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

class UserAuth < ApplicationRecord
  belongs_to :user
end
