# encoding: utf-8
source 'https://rubygems.org'

gem 'rails', '4.2.7.1' #rails 5.1 requires money-rails upgrades which broken tests
gem 'sass-rails', '5.0.6'
gem 'uglifier', '3.2.0'
gem 'coffee-rails', '4.2.1'
gem 'jquery-rails', '4.3.1'
gem 'jquery-turbolinks'
gem 'turbolinks', '5.0.1'
gem 'jbuilder', '~> 2.6.3'

gem 'bootstrap-sass', '~> 3.3.7'
gem 'autoprefixer-rails', '~>6.7.7.2'
gem 'haml-rails', '~> 1.0.0'

# Deploy with Capistrano
gem 'capistrano', '~> 3.8.1'
gem 'capistrano-rails', '~> 1.2.3'
gem 'capistrano-rbenv', '~> 2.1.1'
gem 'capistrano-bundler', '~> 1.2.0'
# gem 'equivalent-xml', '~> 0.5.1'

gem 'pg', '~> 0.20.0'
gem 'fabrication', '~> 2.16.1'
gem 'faker', '~> 1.7.3'
gem 'bootstrap_form', '~> 2.7.0'
gem 'kaminari', '1.0.1'
gem 'omniauth', '1.6.1'
gem 'omniauth-shibboleth', '~> 1.2.1'
gem 'net-sftp'
gem 'money-rails', '~> 1.4.1' # 1.6.0 break tests
gem 'net-ldap', '~> 0.16.0'
gem 'wicked_pdf', '~> 1.1.0'
gem 'wkhtmltopdf-binary', '~>0.12.3.1'
gem 'hydra-ldap'
gem 'nokogiri', '1.7.1'
gem 'coveralls', '~> 0.8.21', require: false

group :development do
  gem 'spring', '~> 2.0.1'
  gem 'letter_opener', '~> 1.4.1'
end

group :development, :test do
  gem 'sqlite3', '~> 1.3.13'
  gem 'rspec-rails', '~> 3.5.2'
  gem 'pry', '~> 0.10.4'
  gem 'capybara', '~> 2.14.0'
  gem 'launchy'
  gem 'simplecov', '~> 0.14.1'
  gem 'rubocop', '~> 0.36.0', require: false
  gem 'rubocop-rspec'
  # gem 'rspec_junit_formatter', '~> 0.2.0'
end

group :test do
  gem 'database_cleaner', '~> 1.5.3'
  gem 'shoulda-matchers', '2.8.0.rc2', require: false
end

group :staging do
  gem 'activerecord-postgresql-adapter'
  gem 'rake', '~> 12.0.0'
end

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.2', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
