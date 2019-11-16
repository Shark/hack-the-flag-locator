namespace :agent do
  desc "Monitors the agent"
  task monitor: :environment do
    monitor = MonitorAgent.new(
      telegram_chat_id: ENV.fetch('TELEGRAM_CHAT_ID'),
      influxdb_url: ENV.fetch('INFLUXDB_URL')
    )
    loop do
      monitor.run
      sleep 60
    end
  end

end
