class DefaultPlayers
  def self.run
    felix = User.find_or_create_by!(name: 'Felix', mac: '00:00:41:c0:6c:9a')
    felix.update!(created_at: Time.now)

    hannes = User.find_or_create_by!(name: 'Hannes', mac: '00:00:e5:0f:dc:e0')
    hannes.update!(created_at: Time.now)

    joe = User.find_or_create_by!(name: 'Joe', mac: '00:00:0a:5d:48:42')
    joe.update!(created_at: Time.now)

    jonas = User.find_or_create_by!(name: 'Jonas', mac: '00:00:b8:04:c2:92')
    jonas.update!(created_at: Time.now)

    kai = User.find_or_create_by!(name: 'Kai', mac: '00:00:59:e7:a7:93')
    kai.update!(created_at: Time.now)
  end
end
