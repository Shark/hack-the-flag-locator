class AddBuildingToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :building, :string
    add_column :users, :floor_timeout, :timestamp
    add_column :users, :from_wifi, :string
    add_column :users, :to_wifi, :string
    add_column :users, :selected_floor, :integer
  end
end
