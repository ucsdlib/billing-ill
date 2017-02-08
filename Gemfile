# encoding: utf-8
source 'https://rubygems.org'

gem 'rails', '5.0.1'
gem 'sass-rails', '5.0.6'
gem 'uglifier', '3.0.2'
gem 'coffee-rails', '4.1.1'
gem 'jquery-rails', '4.2.1'
gem 'jquery-turbolinks'
gem 'turbolinks', '5.0.1'
gem 'jbuilder', '~> 2.6.0'

gem 'bootstrap-sass', '~> 3.3.7'
gem 'autoprefixer-rails', '~>6.4.0.3'
gem 'haml-rails', '~> 0.9.0'

# Deploy with Capistrano
gem 'capistrano', '~> 3.6.1'
gem 'capistrano-rails', '~> 1.1.7'
gem 'capistrano-rbenv', '~> 2.0.4'
gem 'capistrano-bundler', '~> 1.1.4'
# gem 'equivalent-xml', '~> 0.5.1'

gem 'pg', '~> 0.18.4'
gem 'fabrication', '~> 2.15.2'
gem 'faker', '~> 1.6.6'
gem 'bootstrap_form', '~> 2.5.0'
gem 'kaminari', '0.17.0'
gem 'omniauth', '1.3.1'
gem 'omniauth-shibboleth', '~> 1.2.1'
gem 'net-sftp'
gem 'money-rails', '~> 1.4.1' # 1.6.0 break tests
gem 'net-ldap', '~> 0.15.0'
gem 'wicked_pdf', '~> 1.0.6'
gem 'wkhtmltopdf-binary', '~>0.12.3'
gem 'hydra-ldap'
gem 'nokogiri', '1.6.8'
gem 'coveralls', require: false
gem 'rainbow','2.2.1'

group :development do
  gem 'spring', '~> 1.6.2'
  gem 'letter_opener', '~> 1.4.1'
end

group :development, :test do
  gem 'sqlite3', '~> 1.3.11'
  gem 'rspec-rails', '~> 3.5.2'
  gem 'pry', '~> 0.10.3'
  gem 'capybara', '~> 2.6.1'
  gem 'launchy'
  gem 'simplecov'
  gem 'rubocop', require: false
  gem 'rubocop-rspec'
  # gem 'rspec_junit_formatter', '~> 0.2.0'
end

group :test do
  gem 'database_cleaner', '~> 1.5.1'
  gem 'shoulda-matchers', '2.8.0.rc2', require: false
  gem 'rails-controller-testing'
end

group :staging do
  gem 'activerecord-postgresql-adapter'
  gem 'rake', '~> 10.5.0'
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
