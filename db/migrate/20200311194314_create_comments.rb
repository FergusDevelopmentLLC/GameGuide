class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :content
      t.integer :user_id
      t.integer :game_id
      t.integer :created_at
      t.integer :updated_at
    end
  end
end

