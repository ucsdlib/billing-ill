# encoding: utf-8
source 'https://rubygems.org'

gem 'autoprefixer-rails', '~>8.0.0'
gem 'bootstrap-sass', '~> 3.3.7'
gem 'bootstrap_form', '~> 2.7.0'
gem 'capistrano', '~> 3.10.1'
gem 'capistrano-bundler', '~> 1.3.0'
gem 'capistrano-rails', '~> 1.3.1'
gem 'capistrano-rbenv', '~> 2.1.3'
gem 'coffee-rails', '4.2.2'
gem 'coveralls', '~> 0.8.21', require: false
gem 'fabrication', '~> 2.20.1'
gem 'faker', '~> 1.8.7'
gem 'haml-rails', '~> 1.0.0'
gem 'hydra-ldap'
gem 'jbuilder', '~> 2.7.0'
gem 'jquery-rails', '4.3.1'
gem 'jquery-turbolinks'
gem 'kaminari', '1.1.1'
gem 'mail', '2.7.0'
gem 'money-rails', '~> 1.4.1' # 1.6.0 break tests
gem 'net-ldap', '~> 0.16.1'
gem 'net-sftp'
gem 'nokogiri', '1.8.2'
gem 'omniauth', '1.8.1'
gem 'omniauth-shibboleth', '~> 1.3.0'
gem 'pg', '~> 1.0.0'
# rails 5.1 requires money-rails upgrades which broken tests
gem 'rails', '4.2.7.1'
gem 'sass-rails', '5.0.7'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 1.0.0', group: :doc
gem 'turbolinks', '5.1.0'
gem 'uglifier', '4.1.5'
gem 'wicked_pdf', '~> 1.1.0'
gem 'wkhtmltopdf-binary', '~>0.12.3.1'

group :development do
  gem 'letter_opener', '~> 1.6.0'
  gem 'spring', '~> 2.0.2'
end

group :development, :test do
  gem 'capybara', '~> 2.17.0'
  gem 'launchy'
  gem 'pry', '~> 0.11.3'
  gem 'rspec-rails', '~> 3.7.2'
  gem 'rubocop', '~> 0.49.1', require: false
  gem 'rubocop-rspec', '~> 1.16.0'
  gem 'simplecov', '~> 0.14.1'
  gem 'sqlite3', '~> 1.3.13'
end

group :test do
  gem 'database_cleaner', '~> 1.6.2'
  gem 'shoulda-matchers', '2.8.0.rc2', require: false
end

group :staging do
  gem 'activerecord-postgresql-adapter'
  gem 'rake', '~> 12.3.0'
end
