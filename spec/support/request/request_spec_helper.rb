# https://github.com/plataformatec/devise/wiki/How-To:-sign-in-and-out-a-user-in-Request-type-specs-(specs-tagged-with-type:-:request)
module RequestSpecHelper
  extend ActiveSupport::Concern
  include Warden::Test::Helpers

  included do
    before { Warden.test_mode! }

    after { Warden.test_reset! }

    shared_examples 'ログインが必要なページへのアクセス' do
      it 'サインインページにリダイレクトされること' do is_expected.to redirect_to(new_user_session_path) end
    end

    shared_examples 'ログインが必要なリクエスト' do
      it '404エラーになること' do
        expect(subject).to eq 404
      end
    end
  end

  private

  def sign_in(resource)
    login_as(resource, scope: warden_scope(resource))
  end

  def sign_out(resource)
    logout(warden_scope(resource))
  end

  def warden_scope(resource)
    resource.class.name.underscore.to_sym
  end
end
