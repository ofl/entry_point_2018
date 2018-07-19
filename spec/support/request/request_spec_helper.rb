# https://github.com/plataformatec/devise/wiki/How-To:-sign-in-and-out-a-user-in-Request-type-specs-(specs-tagged-with-type:-:request)
module RequestSpecHelper
  include Warden::Test::Helpers

  def self.included(base)
    base.before(:each) { Warden.test_mode! }
    base.after(:each) { Warden.test_reset! }
  end

  def sign_in(resource)
    login_as(resource, scope: warden_scope(resource))
  end

  def sign_out(resource)
    logout(warden_scope(resource))
  end

  shared_examples 'ログインしていないユーザーはサインインページにリダイレクトされる' do
    it 'サインインページにリダイレクトされること' do is_expected.to redirect_to(new_user_session_path) end
  end

  shared_examples 'ログインしていない場合は404エラーになること' do
    it '404エラーになること' do
      expect(subject).to eq 404
    end
  end

  private

  def warden_scope(resource)
    resource.class.name.underscore.to_sym
  end
end
