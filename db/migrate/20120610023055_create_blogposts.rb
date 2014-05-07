class CreateBlogposts < ActiveRecord::Migration
  def change
    create_table :blogposts do |t|
      t.string :titel
      t.string :url_slug
      t.text :inhalt
      t.integer :user_id
      t.integer :bild_id

      t.timestamps
    end
    add_index :blogposts, :created_at
    add_index :blogposts, :url_slug
  end
end
