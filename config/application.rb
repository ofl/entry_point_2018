require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EntryPoint2018
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.generators do |g|
      g.assets false
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.i18n.available_locales = %i[ja en]
    config.i18n.enforce_available_locales = true
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.eager_load_paths << Rails.root.join('lib')
    config.time_zone = 'Tokyo'

    require_relative '../lib/entry_point_2018/exceptions'
    config.middleware.insert(0, EntryPoint2018::ExceptionHandler)

    config.assets.enabled = false
  end
end
