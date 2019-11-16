namespace :user do
  desc 'update user locations'
  task :update => :environment do
    updater = UserUpdater.new(influxdb_url: ENV.fetch('INFLUXDB_URL'))
    loop do
      updater.run
      sleep 5
    end
  end

  desc 'communicate with users on registration page'
  task user_registration: :environment do
    communicator = UserCommunicator.new(influxdb_url: ENV.fetch('INFLUXDB_URL'))
    loop do
      communicator.run
      sleep 5
    end
  end

  desc 'import a JSON file, usage: user:import[path]'
  task :import, [:file] => :environment do |t, args|
    ImportUser = Struct.new(:timestamp, :mac, :x, :y, :z)
    stats = {created: 0, skipped: 0}

    f = File.open(args.file, 'r')
    raw_users = JSON.load(f)
    f.close
    users = []

    raw_users.each do |m|
      m['notifications'].each do |n|
        unless n['notificationType'] == 'locationupdate'
          stats[:skipped] += 1
          next
        end

        unless n['hierarchyDetails']['building']['name'] == 'Väre'
          stats[:skipped] += 1
          next
        end

        users << ImportUser.new(
          Time.at(Integer(n['timestamp']) / 1000),
          n['deviceId'],
          Integer(n['locationCoordinate']['x']),
          Integer(n['locationCoordinate']['y']),
          Integer(n['hierarchyDetails']['floor']['name'])
        )
        stats[:created] += 1
      end
    end

    puts "Created: #{stats[:created]}, skipped: #{stats[:skipped]}"

    users.each do |u|
      User.create!(
        name: "#{Faker::Hacker.adjective}#{Faker::Food.ingredient}".delete(' '),
        mac: u.mac,
        x_coordinate: u.x,
        y_coordinate: u.y,
        floor: u.z
      )
    end
  end
end
