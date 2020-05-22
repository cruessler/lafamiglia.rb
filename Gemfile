source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 5.2', '< 6.0'

# Rails 5.0 has removed `assigns` in controller tests and extracted the
# functionality to a gem.
gem 'rails-controller-testing'

# Use PostgreSQL as the database for Active Record
gem 'pg', '~> 1.2'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 5.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library (made obsolete by the use of bower)
# gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.10'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# http://capistranorb.com/documentation/getting-started/installation/
group :development do
  gem 'capistrano-rails', '~> 1.4.0'

  # Reduces boot times through caching; required in config/boot.rb
  gem 'bootsnap', '>= 1.1.0', require: false
end

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'thin'

# https://github.com/svenfuchs/rails-i18n
gem 'rails-i18n', '~> 5.1.3' # For 4.0.x

# https://github.com/plataformatec/simple_form
gem 'simple_form', '~> 5.0'

gem 'devise', '~> 4.7'
gem 'devise-i18n'
gem 'responders', '~> 3.0'

# https://github.com/makandra/consul
# Used for authorization and access control
gem 'consul', '~> 1.0.3'

# https://github.com/amatsuda/kaminari
gem 'kaminari', '~> 1.2'

# https://github.com/evanphx/benchmark-ips
gem 'benchmark-ips', '~> 2.8.2'

group :development do
  # https://github.com/deivid-rodriguez/byebug
  gem 'byebug', '~> 11.1'

  gem 'web-console', '~> 3.0'

  # This gem was added to address an error message provided by ActiveSupport
  # 5.1.6.
  gem 'listen'
end
