class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :user_id
      t.string :name
      t.integer :created_at
      t.integer :updated_at
    end
  end
end
