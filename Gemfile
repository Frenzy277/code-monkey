source 'https://rubygems.org'
ruby '2.1.5'

gem 'rails', '4.1.8'
gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'haml-rails'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'bcrypt', '~> 3.1.7'
gem 'pg'

group :development do
  gem 'thin'
  gem 'spring'
  gem 'hirb'
  gem 'quiet_assets'
end

group :development, :test do
  gem 'spring-commands-rspec'
  gem 'faker'
  gem 'fabrication'
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '2.99'
end

group :test do
  gem 'capybara'
  gem 'launchy'
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers', require: false
end

group :production do
  gem 'rails_12factor'
end

# Use unicorn as the app server
# gem 'unicorn'