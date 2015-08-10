source 'https://rubygems.org'


gem 'rails', '4.2.2'
gem 'sass-rails', '5.0.3'
gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'turbolinks'
gem 'jbuilder'

gem 'bootstrap-sass', '~> 3.2.0'
gem 'autoprefixer-rails'
gem 'haml-rails'

# Deploy with Capistrano
gem 'capistrano', '~> 3.3.3'
gem 'capistrano-rails', '~> 1.1.2'
gem 'capistrano-rbenv', github: "capistrano/rbenv"
gem 'capistrano-bundler', '~> 1.1.3'
#gem 'equivalent-xml', '~> 0.5.1'

gem 'pg'
gem 'fabrication'
gem 'faker'
gem 'bootstrap_form'
gem 'kaminari'
gem 'omniauth'
gem 'omniauth-shibboleth'
gem 'net-sftp'
gem 'money-rails'
gem 'net-ldap'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary', '0.9.9'

group :development do
  gem 'spring'
  gem "letter_opener"
end

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails', '3.1'
  gem 'pry'
  gem 'capybara'
  gem 'launchy'
  gem 'simplecov'
 # gem 'rspec_junit_formatter', '~> 0.2.0'
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers', require: false, github: 'thoughtbot/shoulda-matchers', branch: 'master'
  gem "codeclimate-test-reporter", require: nil
end

group :staging do
  gem 'activerecord-postgresql-adapter'
  gem 'rake', '~> 10.4.0'
end

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc


# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
