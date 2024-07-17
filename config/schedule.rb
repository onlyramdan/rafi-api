# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
# config/schedule.rb
set :output, "./log/cron.log"

every 10.minutes do
    rake "mqtt:save_db"
    rake 'sample:test'
end
# config/schedule.rb

# config/schedule.rb

# Set the environment to 'development'
# ENV['RAILS_ENV'] = 'development'

# # Define the job type for Rails runner
# job_type :runner, "cd /mnt/c/peruri/iot/api1809nw && bundle exec bin/rails runner -e development ':task' :output"

# # Set the output log file to 'log/cron.log'
# set :output, '/mnt/c/peruri/iot/api1809nw/log/cron.log'

# # Schedule the job to run every minute
# every 1.minute do
#   runner "puts 'Hello, world!'", :environment => 'development'
# end
# set :output, "./log/cron.log"
# every 1.minutes do
#     rake 'sample:test'
# end
  

