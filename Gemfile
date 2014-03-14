source 'https://rubygems.org'
if ENV['DYNO']  # on heroku?
  ruby '1.9.3', engine: 'jruby', engine_version: '1.7.9'
else
  ruby '1.9.3'
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.0.1'
gem 'google_drive'
gem 'mail'

gem 'bootstrap-sass', '~> 3.1.1'

platforms :jruby do
  gem 'rmagick4j', require: false
  gem 'therubyrhino'
  gem 'activerecord-jdbc-adapter', :require => false
end

platforms :ruby do
  gem 'rmagick', require: false
  gem 'jruby-jars', require: false
end

gem 'zxing', git: 'git://github.com/palfvin/zxing.rb.git', require: false
gem 'peach'

group :development, :test do

  gem 'prawn'
  gem 'prawn-qrcode'
  gem 'pry'

  platforms :ruby do
    gem 'sqlite3'
    gem 'pry-debugger'
    gem 'pry-stack_explorer'
  end

  platform :jruby do
    gem 'jdbc-sqlite3', require: false
  end

end

group :test do
  gem 'rspec', '~> 3.0.0.beta2'
  gem 'rspec-rails', '~> 3.0.0.beta2'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'selenium-webdriver'
end

# gem 'tesseract-ocr'


group :production do
  platform :jruby do
    gem 'activerecord-jdbcpostgresql-adapter', require: false
  end
  gem 'rails_12factor'
end

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
