class UserUpdater
  def initialize(influxdb_url:)
    @db = InfluxDB::Client.new(url: influxdb_url, open_timeout: 3)
  end

  def run
    movements = db.query('select x, y, z, building from movement where time > now() - 3m group by mac order by time desc limit 1;')
    active_user_macs = User.where('mac is not null').pluck(:mac)

    movements.each do |m|
      mac = m['tags']['mac']
      x = m['values'].first['x']
      y = m['values'].first['y']
      z = m['values'].first['z']
      building = m['values'].first['building']

      if active_user_macs.include?(mac)
        User.where(mac: mac).update_all(
          x_coordinate: x,
          y_coordinate: y,
          floor: z,
          building: building
        )
        puts "updated #{mac}"
      end
    end
  end

  private

  attr_reader :db
end
