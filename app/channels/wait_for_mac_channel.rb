class WaitForMacChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def update_floor(data)
    current_user.update(selected_floor: data['floor'])
    WaitForMacChannel.broadcast_to current_user, type: 'WAIT'
  end

  def update_to_wifi(data)
    current_user.update(to_wifi: data['wifi'])
    WaitForMacChannel.broadcast_to current_user, type: 'WAIT'
  end

  def update_from_wifi(data)
    current_user.update(from_wifi: data['wifi'])
    WaitForMacChannel.broadcast_to current_user, type: 'WAIT'
  end
end
