# == Schema Information
#
# Table name: user_auths
#
#  id                   :integer          not null, primary key
#  user_id              :integer          not null
#  provider             :integer          default("email"), not null
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

  enum provider: {
    email: 0,
    facebook: 1,
    twitter: 2
  }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  scope :confirmed, -> { where.not(confirmed_at: nil) }

  validates :user_id, presence: true
  validates :uid, presence: true
  validates :uid, format: { with: VALID_EMAIL_REGEX }, if: :email?
  validates :provider, presence: true, inclusion: { in: providers }
  validates_associated :user

  class ConfirmationExpired < StandardError; end

  def confirmed?
    !confirmed_at.nil?
  end

  def add_confirmation_token
    generate_confirmation_token
    self.confirmation_sent_at = Time.current
    generate_temporary_uid if external_auth_provider?
  end

  def confirme!(datetime: Time.zone.now)
    self.class.where(user: user, provider: provider).where.not(id: id).find_each do |old_auth|
      old_auth.update!(confirmed_at: nil)
    end
    self.confirmed_at ||= datetime
    generate_confirmation_token # disable current token
    save!
  end

  def confirm_by_token!(at: Time.current)
    if confirmation_sent_at + ENV['CONFIRMATION_MAIL_EXPIRED'].to_i.minutes > at
      confirme!
      return
    end
    raise ConfirmationExpired
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

  def send_confirmation_instructions
    if email? && save
      AuthenticationMailer.confirmation_instructions(user, self).deliver_now
      true
    else
      false
    end
  end

  def external_auth_provider?
    facebook? || twitter?
  end

  private

  def valid_password?
    return true if user.valid_password?(password)
    errors.add(:password, 'invalid')
    false
  end

  def auth_provider(name:)
    case name
    when 'twitter'
      AuthProviders::Twitter.new
    when 'facebook'
      AuthProviders::Facebook.new
    end
  end
end
