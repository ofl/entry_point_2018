# Deviseメールの送信に利用
class AuthenticationMailer < Devise::Mailer
  def confirmation_instructions(user, user_auth)
    @resource = user
    @token = user_auth.confirmation_token
    @provider = user_auth.provider
    mail(to: user_auth.uid, subject: 'confirmation', from: 'aaa@example.com')
  end
end
