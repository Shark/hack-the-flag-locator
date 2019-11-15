class CreateUser < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :mac
      t.integer :x_coordinate
      t.integer :y_coordinate
      t.integer :floor
      t.timestamps
    end
  end
end
