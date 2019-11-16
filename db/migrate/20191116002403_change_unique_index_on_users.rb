class ChangeUniqueIndexOnUsers < ActiveRecord::Migration[5.2]
  def up
    remove_index :users, name: :index_users_on_name
    add_index :users, [:name, :mac], unique: true
  end

  def down
    remove_index :users, name: :index_users_on_name_and_mac
    add_index :users, :name, unique: true
  end
end
