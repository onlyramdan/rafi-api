source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.0"
# ruby "2.7.2"
# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.7", ">= 7.0.7.2"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# gem 'sidekiq', '7.2.1'


# gem 'sidekiq-scheduler', '~> 5.0', '>= 5.0.3'
#MQTT
gem 'mqtt', '~> 0.4.0'

#Mongo
gem 'mongoid', '~> 7.0'

#kiminari
gem 'kaminari-mongoid'

gem 'bcrypt', '~> 3.1.7'

# gem 'sidekiq-cron', '~> 1.1'
gem 'whenever', '~> 1.0', require: false
# gem 'whenever', require: false
#
# gem 'activerecord'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem "rack-cors"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end


# gem "sidekiq", "~> 7.2"
