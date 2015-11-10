# encoding: utf-8
source 'https://rubygems.org'

gem 'rails', '4.2.4'
gem 'sass-rails', '5.0.4'
gem 'uglifier', '2.7.2'
gem 'coffee-rails'
gem 'jquery-rails', '4.0.5'
gem 'jquery-turbolinks'
gem 'turbolinks'
gem 'jbuilder', '~> 2.3.2'

gem 'bootstrap-sass', '~> 3.3.5'
gem 'autoprefixer-rails', '~>6.1.0'
gem 'haml-rails', '~> 0.9.0'

# Deploy with Capistrano
gem 'capistrano', '~> 3.4.0'
gem 'capistrano-rails', '~> 1.1.5'
gem 'capistrano-rbenv', github: 'capistrano/rbenv'
gem 'capistrano-bundler', '~> 1.1.4'
# gem 'equivalent-xml', '~> 0.5.1'

gem 'pg', '~> 0.18.3'
gem 'fabrication', '~> 2.14.1'
gem 'faker', '~> 1.5.0'
gem 'bootstrap_form', '~> 2.3.0'
gem 'kaminari'
gem 'omniauth'
gem 'omniauth-shibboleth', '~> 1.2.1'
gem 'net-sftp'
gem 'money-rails', '~> 1.4.1'
gem 'net-ldap', '~> 0.12.0'
gem 'wicked_pdf', '~> 1.0.0'
gem 'wkhtmltopdf-binary', '~>0.9.9'
gem 'hydra-ldap'

group :development do
  gem 'spring', '~> 1.4.1'
  gem 'letter_opener', '~> 1.4.1'
end

group :development, :test do
  gem 'sqlite3', '~> 1.3.11'
  gem 'rspec-rails', '~> 3.3.3'
  gem 'pry', '~> 0.10.3'
  gem 'capybara', '~> 2.5.0'
  gem 'launchy'
  gem 'simplecov'
  gem 'rubocop', require: false
  gem 'rubocop-rspec'
  # gem 'rspec_junit_formatter', '~> 0.2.0'
end

group :test do
  gem 'database_cleaner', '~> 1.5.1'
  gem 'shoulda-matchers', '2.8.0.rc2', require: false
  gem 'codeclimate-test-reporter', require: nil
end

group :staging do
  gem 'activerecord-postgresql-adapter'
  gem 'rake', '~> 10.4.0'
end

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
