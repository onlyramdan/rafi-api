# # lib/tasks/mqtt.rake

# namespace :mqtt do
#     task save_db: :environment do
#       # Isi dengan logika Anda untuk menjalankan save_db
#       topic = "64fed92dabf2c214987bf91b"
#     #   topic, message = @client.get(topic)
#       topic, message = @client.get(topic) if @client.present?
#       Rails.logger.info "==============> HEADER: #{topic}"
  
#       if message
#         json_data = JSON.parse(message)
#         data_alat = json_data
  
#         data = {
#           alat_id: "65bfbaa65003e313f55a6c6c",
#           lux: data_alat["lux"],
#           amonia: data_alat["Co2"],
#           kebisingan: data_alat["tingkat_kebisingan"],
#         }
  
#         @monitoring = Monitoring.new(data)
  
#         if @monitoring.save
#           Rails.logger.info "Data saved successfully!"
#         else
#           Rails.logger.error "Error saving data: " + @monitoring.errors.full_messages.join(", ")
#         end
#       else
#         Rails.logger.error "No message received."
#       end
#     end
# end


# lib/tasks/mqtt.rake
namespace :mqtt do
  desc "Save data to the database"
  task save_db: :environment do
    require 'net/http'

    uri = URI('http://localhost:4000/mqtt/save_db') # Update with your actual domain
    response = Net::HTTP.post(uri, nil)
    puts response.body
  end
end
