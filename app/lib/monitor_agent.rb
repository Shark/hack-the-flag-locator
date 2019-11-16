class MonitorAgent
  def initialize(influxdb_url:, telegram_chat_id:)
    @db = InfluxDB::Client.new(url: influxdb_url, open_timeout: 3)
    @telegram_chat_id = telegram_chat_id
  end

  def run
    movements = db.query("select count(x) from movement where time > now()-1m")
    unless movements.count > 0
      Telegram.bot.send_message(
        chat_id: telegram_chat_id,
        text: 'Agent seems to be broken, no movements were imported during the last minute',
      )
    end
  end

  private

  attr_reader :db, :telegram_chat_id
end
