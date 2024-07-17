require 'mqtt'
require 'timeout'
class MqttController < ApplicationController
  # include Sidekiq::Worker
  before_action :connect_to_mqtt, only: [:subscribe_to_topic, :mqtt_off, :lampu, :save_db]

  # require 'mqtt'

  # def connect_to_mqtt
  #   begin
  #     @client = MQTT::Client.connect(
  #       host: ENV['MQTT_HOST'] || '103.59.95.173',
  #       port: ENV['MQTT_PORT'] || 1883,
  #       username: ENV['MQTT_USERNAME'] || 'iot',
  #       password: ENV['MQTT_PASSWORD'] || 'password'
  #     )
  #     @client = MQTT::Client.connect(
  #       host: ENV['MQTT_HOST'] || '34.101.114.53',
  #       port: ENV['MQTT_PORT'] || 1883,
  #       username: ENV['MQTT_USERNAME'] || 'onlyramdan',
  #       password: ENV['MQTT_PASSWORD'] || 'Sarimiisi8'
  #     )
  #     Rails.logger.info 'Connected to MQTT broker'
  #   rescue MQTT::ProtocolException, MQTT::Exception => e
  #     Rails.logger.error "Failed to connect to MQTT broker: #{e.message}"
  #   end
  # end
  
  def connect_to_mqtt
    Thread.new do
      begin
        host = ENV['MQTT_HOST'].presence || '103.59.95.173'
        port = (ENV['MQTT_PORT'].presence || 1883).to_i
        username = ENV['MQTT_USERNAME'].presence || 'iot'
        password = ENV['MQTT_PASSWORD'].presence || 'password'
  
        Timeout.timeout(10) do
          @client = MQTT::Client.connect(
            host: host,
            port: port,
            username: username,
            password: password
          )
        end
  
        Rails.logger.info 'Connected to MQTT broker'
      rescue Timeout::Error
        Rails.logger.error "Connection to MQTT broker timed out"
      rescue MQTT::ProtocolException, MQTT::Exception => e
        Rails.logger.error "Failed to connect to MQTT broker: #{e.message}"
      end
    end.join
  end
  
  def subscribe_to_topic
    topic = "64fed92dabf2c214987bf91b"  # Atur topik sesuai dengan kebutuhan Anda
    
    if topic.nil? || topic.empty?
      render json: { error: 'Topic is missing' }, status: :unprocessable_entity
      return
    end
    
    if @client.present?
      begin
        topic, message = @client.get(topic)
  
        if message.nil?
          render json: { error: 'No message received for the topic' }, status: :unprocessable_entity
          return
        end
      rescue MQTT::TimeoutError => e
        Rails.logger.error "MQTT operation timed out: #{e.message}"
        render json: { error: 'MQTT operation timed out' }, status: :internal_server_error
        return
      end
    else
      render json: { error: 'MQTT client is not present' }, status: :internal_server_error
      return
    end
    
    Rails.logger.info "==============> HEADER: #{topic}"
    
    begin
      json_data = JSON.parse(message)
      # Handle nil case for json_data
      data_alat = json_data || {}
  
      render json: data_alat
    rescue JSON::ParserError => e
      Rails.logger.error "Failed to parse JSON data: #{e.message}"
      render json: { error: 'Failed to parse JSON data' }, status: :unprocessable_entity
    end
  end
  
  
  

  # def subscribe_to_topic
  #   # topic = params["topic"]
  #   topic = "64fed92dabf2c214987bf91b"
  #   topic, message = @client.get(topic) if @client.present?
  #   # topic, message = @client.get(topic) # Menunggu hingga ada pesan masuk
  #   Rails.logger.info "==============> HEADER: #{topic}"
  #   # Di sini Anda dapat memproses pesan sesuai kebutuhan Anda
  #   if message
  #     # Jika ada pesan yang diterima, Anda dapat mengonversinya ke JSON jika sesuai
  #     json_data = JSON.parse(message)
  #     # Sekarang, Anda dapat menggunakan json_data untuk pemrosesan lebih lanjut
  #     data_alat = json_data

  #     render json: data_alat
  #     # if data_alat.present?
  #     #   data = [
  #     #     alat: nama_alat,
  #     #     # suhu: suhu,
  #     #     # kelembaban: kelembaban,
  #     #     kebisingan: kebisingan,
  #     #     lux: lux,
  #     #     debu: debu,
  #     #     amonia: amonia
          
  #     #   ]
  #     #   @monitoring = Monitoring.new(data)

  #     #   if @monitoring.save
  #     #     render json: @monitoring, status: :created, location: @monitoring
  #     #   else
  #     #     render json: @monitoring.errors, status: :unprocessable_entity
  #     #   end       
  #     # end
  #   else
  #     # Tindakan yang akan diambil jika tidak ada pesan yang diterima
  #     render json: { error: 'No message received' }
  #   end
  # end

  def save_db
    topic = "64fed92dabf2c214987bf91b"
    topic, message = @client.get(topic)
    Rails.logger.info "==============> HEADER: #{topic}"
    
    if message
      json_data = JSON.parse(message)
      data_alat = json_data
  
      # Set default values to 0 if the corresponding keys are not present in data_alat
      lux = data_alat["lux"].presence || 0
      debu = data_alat["debu"].presence || 0
      amonia = data_alat["Co2"].presence || 0
      kebisingan = data_alat["suara"].presence || 0
  
      data = {
        alat_id: "65bfbaa65003e313f55a6c6c",
        lux: lux,
        debu: debu,
        amonia: amonia,
        kebisingan: kebisingan,
      }
  
      @monitoring = Monitoring.new(data)
      if @monitoring.save
        render json: @monitoring, status: :created, location: @monitoring
      else
        render json: @monitoring.errors, status: :unprocessable_entity
      end
    else
      # If no message received, store default values in the database
      data = {
        alat_id: "65bfbaa65003e313f55a6c6c",
        lux: 0,
        debu: 0,
        amonia: 0,
        kebisingan: 0,
      }
  
      @monitoring = Monitoring.new(data)
      if @monitoring.save
        render json: @monitoring, status: :created, location: @monitoring
      else
        render json: @monitoring.errors, status: :unprocessable_entity
      end
    end
  end
  

  # def save_db
  #   topic = "64fed92dabf2c214987bf91b"
  #   topic, message = @client.get(topic)
  #   Rails.logger.info "==============> HEADER: #{topic}"
  #   if message
  #     json_data = JSON.parse(message)
  #     data_alat = json_data

  #     data = {
  #       alat_id: "65bfbaa65003e313f55a6c6c",
  #       lux: data_alat["lux"],
  #       debu: data_alat["debu"],
  #       amonia: data_alat["Co2"],
  #       kebisingan: data_alat["tingkat_kebisingan"],
  #     }

  #     @monitoring = Monitoring.new(data)
  #     if @monitoring.save
  #       render json: @monitoring, status: :created, location: @monitoring
  #     else
  #       render json: @monitoring.errors, status: :unprocessable_entity
  #     end

  #   else
  #     render json: { error: 'No message received' }
  #   end
  # end
  
  def mqtt_off
    @client.disconnect
    Rails.logger.info 'Disconnected'
  end

  def lampu
    @client.publish('inTopic', params['id'])
    render json: { status: 'Message sent' }
  end
end