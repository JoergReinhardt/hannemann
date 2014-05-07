class Aufraumen < ActiveRecord::Migration
  def change
    add_index :blogposts, [:url_slug, :created_at]
    add_index :blogposts, [:user_id, :url_slug]
  end

  def up
  end

  def down
  end
end
