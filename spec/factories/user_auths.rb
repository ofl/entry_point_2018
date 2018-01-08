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
