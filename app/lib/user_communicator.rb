class UserCommunicator
  def initialize(influxdb_url:)
    @db = InfluxDB::Client.new(url: influxdb_url, open_timeout: 3)
    @locator = DeviceLocator.new(influxdb_url: influxdb_url)
  end

  def run
    # awaiting instructions
    User.awaiting_instructions.each do |user|
      puts "#{user.name} awaiting instructions"
      WaitForMacChannel.broadcast_to user, type: 'WIFI', userCount: locator.total_user_count
    end

    # selected current wifi
    User.selected_current_wifi.each do |user|
      puts "#{user.name} selected current wifi"
      WaitForMacChannel.broadcast_to user, type: 'CHANGE_WIFI', userCount: locator.total_user_count(ssid: user.from_wifi)
    end

    # selected both wifis but not the floor
    switched = locator.switched_users
    User.selected_to_wifi.without_selected_floor.each do |user|
      puts "#{user.name} selected both wifis"
      possible_users = switched.find_all do |mac, infos|
        infos[:from] == user.from_wifi and infos[:to] == user.to_wifi
      end.to_h

      if possible_users.count == 0
        puts 'oops an eror'
      elsif possible_users.count == 1
        puts 'it just works'
        user.update! mac: possible_users.keys.first
        WaitForMacChannel.broadcast_to user, type: 'MAC_FOUND', url: 'http://www.google.com/search?q=fickdich'
      else
        WaitForMacChannel.broadcast_to user, type: 'FLOOR', userCount: possible_users.count
      end
    end

    # select both wifis and the floor
    User.selected_to_wifi.with_selected_floor.each do |user|
      puts "#{user.name} selected the floor as well"
      possible_users = switched.find_all do |mac, infos|
        infos[:from] == user.from_wifi and infos[:to] == user.to_wifi and infos[:floor] == user.selected_floor
      end.to_h

      if possible_users.count == 0
        puts 'oops an eror'
      elsif possible_users == 1
        puts 'it just works'
        user.update! possible_users.keys.first
        WaitForMacChannel.broadcast_to user, type: 'MAC_FOUND', url: 'http://www.google.com/search?q=fickdich'
      else
        puts 'go somewhere else and try again'
      end

    end
  end

  private

  attr_reader :db, :locator
end
