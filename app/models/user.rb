# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           not null
#  encrypted_password     :string           not null
#  username               :string           not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  authentication_token   :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#

class User < ApplicationRecord
  attr_accessor :login

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable, :omniauthable,
         :recoverable, :rememberable, :trackable, :omniauthable,
         :validatable, authentication_keys: [:login]

  validates :username, format: { with: /\A[a-zA-Z0-9_\.]*\z/ }

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    if login
      where(conditions.to_h).find_by(['lower(username) = :value OR lower(email) = :value', { value: login.downcase }])
    elsif conditions.key?(:username) || conditions.key?(:email)
      find_by(conditions.to_h)
    end
  end

  def confirmed_by?(provider)
    provider
  end
end
