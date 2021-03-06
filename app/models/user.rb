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

class User < ApplicationRecord
  include PointAvailable
  include AvatarUploader[:avatar]

  attr_accessor :login, :dummy_password

  MIN_USERNAME_LENGTH = Settings.models.user.username.minlength
  MAX_USERNAME_LENGTH = Settings.models.user.username.maxlength

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable, :omniauthable,
         :recoverable, :rememberable, :trackable, :omniauthable,
         :validatable, authentication_keys: [:login]

  validates :username, format: { with: /\A[a-zA-Z0-9_\.]*\z/ },
                       length: { minimum: MIN_USERNAME_LENGTH, maximum: MAX_USERNAME_LENGTH },
                       uniqueness: true

  has_many :user_auths, dependent: :destroy
  has_many :confirmed_user_auths, -> { merge(UserAuth.confirmed) }, class_name: :UserAuth, inverse_of: :user
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  before_create :ensure_dummy_authentication_token
  before_destroy :outdate_all_points! # 所持しているポイントを無効にする

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    if login
      where(conditions.to_h).find_by(['lower(username) = :value OR lower(email) = :value', { value: login.downcase }])
    elsif conditions.key?(:username) || conditions.key?(:email)
      find_by(conditions.to_h)
    end
  end

  def confirmed?
    confirmed_user_auths.present?
  end

  def confirmed_by?(provider)
    confirmed_user_auths.select { |auth| auth.send("#{provider}?") }.present?
  end

  def raw_reset_password_token
    set_reset_password_token
  end

  def update_authentication_token!
    self.authentication_token = "#{id}:#{Devise.friendly_token}"
    save!
  end

  def reset_authentication_token!
    ensure_dummy_authentication_token
    save!
  end

  # ダミーのメールアドレスを適用する
  def ensure_dummy_email_address
    self.email = loop do
      address = "#{Devise.friendly_token}@#{Settings.domain}"
      break address unless User.find_by(email: address)
    end
  end

  def auth_with_email?
    email.present? && !dummy_email?
  end

  def valid_except_email?
    return false if errors[:username].any? || errors[:password].any?

    errors[:email].any?
  end

  private

  def ensure_dummy_authentication_token
    self.authentication_token = loop do
      token = Devise.friendly_token
      break token unless User.find_by(authentication_token: token)
    end
  end

  def dummy_email?
    Regexp.new(".+@#{Settings.domain}\\z").match(email)
  end
end
