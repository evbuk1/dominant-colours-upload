source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4"

gem 'dotenv-rails'
gem 'elasticsearch'
gem 'factory_bot'
gem 'factory_bot_rails', require: false
gem 'jsonapi-serializer'
gem 'kaminari'
gem 'pg'
gem 'pundit'
gem 'rspec'
gem 'rspec-rails'
gem 'rswag'
gem 'rubocop', require: false
gem 'rubocop-rails', require: false
gem 'rubocop-rake', require: false
gem 'rubocop-rspec', require: false
gem 'shopify-money', require: 'money'
gem 'sorcery'
gem 'typhoeus'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false


# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

