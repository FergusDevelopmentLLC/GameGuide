class AddColumnsToGames < ActiveRecord::Migration
  def change
    add_column :games, :featured, :integer
    add_column :games, :number_of_players, :string
    add_column :games, :play_length, :string
    add_column :games, :image, :string
  end
end
