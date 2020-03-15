class CreateGameTagUsers < ActiveRecord::Migration
  def change
    create_table :game_tag_users do |t|
      t.integer :game_id
      t.integer :tag_id
      t.integer :user_id
    end
  end
end
