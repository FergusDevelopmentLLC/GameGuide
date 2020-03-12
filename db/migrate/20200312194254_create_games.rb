class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :type_id
      t.integer :user_id
      t.string :name
      t.string :short_description
      t.string :description
      t.integer :created_at
      t.integer :updated_at
    end
  end
end
