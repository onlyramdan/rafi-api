# app/workers/mqtt_controller_worker.rb
class MqttControllerWorker
    include Sidekiq::Worker
  
    def perform
      MqttController.new.save_db
    end
end
  