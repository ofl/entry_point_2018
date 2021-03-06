source 'https://rubygems.org'
ruby '2.4.4'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.1'
# Use postgres as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'active_model_serializers'

gem 'bootsnap', require: false
gem 'bootstrap_form',
    git: 'https://github.com/bootstrap-ruby/bootstrap_form.git',
    branch: 'master'

gem 'aws-sdk-s3', '~> 1.2'
gem 'config'
gem 'devise'
gem 'fast_jsonapi'
gem 'foreman'
gem 'graphql'
gem 'graphql-batch'
gem 'kaminari'
gem 'shrine', '~> 2.0'
gem 'slim'

gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'

gem 'koala', '~> 2.2'
gem 'twitter'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'license_finder'
  gem 'rspec-rails', '~> 3.5.0'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'brakeman'
  gem 'bullet'
  gem 'bundler-audit'
  gem 'graphiql-rails'
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'guard-rubocop', require: false
  gem 'letter_opener'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'migration_comments'
  gem 'rack-mini-profiler'
  gem 'rufo'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
end

group :test do
  # gem 'autodoc'
  gem 'email_spec'
  gem 'shoulda-matchers'
  gem 'shrine-memory'
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'vcr'
  gem 'webmock'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data'
