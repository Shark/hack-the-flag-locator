class User < ApplicationRecord
  validates :name, presence: true

  scope :ready, -> { where('updated_at < ?', 5.seconds.ago) }
  scope :awaiting_instructions, -> { where(from_wifi: nil).where(to_wifi: nil).where('created_at < ?', 5.seconds.ago) }
  scope :selected_current_wifi, -> { where.not(from_wifi: nil).where(to_wifi: nil).ready }
  scope :selected_to_wifi, -> { where.not(from_wifi: nil).where.not(to_wifi: nil).where(mac: nil).ready }
  scope :without_selected_floor, -> { where(selected_floor: nil) }
  scope :with_selected_floor, -> { where.not(selected_floor: nil) }
end
