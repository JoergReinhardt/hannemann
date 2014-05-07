class AddIndexToUsersLogin < ActiveRecord::Migration
  def change
    add_index :users, [:login, :created_at]
  end
end
