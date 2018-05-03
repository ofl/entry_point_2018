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

class UserAuth < ApplicationRecord
  attr_accessor :user_password

  belongs_to :user

  enum provider: {
    email: 0,
    facebook: 1,
    twitter: 2
  }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  scope :confirmed, -> { where.not(confirmed_at: nil) }

  validates :user, :uid, presence: true
  validates :uid, format: { with: VALID_EMAIL_REGEX }, if: :email?
  validates :provider, presence: true, inclusion: { in: providers }
  validates_associated :user
  validate :confirm_user_password, on: :need_password

  class ConfirmationExpired < StandardError; end

  def confirmed?
    !confirmed_at.nil?
  end

  def add_confirmation_token
    generate_confirmation_token
    self.confirmation_sent_at = Time.current
    generate_temporary_uid if external_auth_provider?
  end

  def confirme!(now: Time.current)
    transaction do
      disable_old_auths!
      self.confirmed_at = now
      generate_confirmation_token # disable current token
      save!
    end
  end

  def confirm_user_password
    return if user.valid_password?(user_password)
    errors.add(:user_password)
  end

  def confirm_by_token!(now: Time.current)
    raise ConfirmationExpired if confirmation_time_out?(now: now)
    confirme!
  end

  def verified_by_auth_provider?(params)
    provider = auth_provider(name: params[:provider])
    return false unless provider

    user_account = provider.user_account(params)
    if uid == user_account[:uid].to_s
      self.access_token = params[:access_token]
      self.access_secret = params[:access_secret]
      confirme!
      return true
    end
    false
  end

  def generate_confirmation_token
    loop do
      self.confirmation_token = Devise.friendly_token
      break if self.class.find_by(confirmation_token: confirmation_token).nil?
    end
  end

  def generate_temporary_uid
    self.uid ||= Devise.friendly_token
  end

  def external_auth_provider?
    facebook? || twitter?
  end

  def send_confirmation_instructions
    AuthenticationMailer.confirmation_instructions(user, self).deliver_now
  end

  def confirmation_time_out?(now: Time.current)
    return true if confirmation_sent_at.nil?
    confirmation_sent_at + Settings.confirmation.mail_expired.minutes < now
  end

  private

  def auth_provider(name:)
    case name
    when 'twitter'
      AuthProviders::Twitter.new
    when 'facebook'
      AuthProviders::Facebook.new
    end
  end

  # 古い本人確認のconfirmed_atをnilにする
  def disable_old_auths!
    self.class.where(user: user, provider: provider).where.not(id: id).find_each do |old_auth|
      old_auth.update!(confirmed_at: nil)
    end
  end
end
