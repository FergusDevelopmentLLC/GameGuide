class Tag < ActiveRecord::Base
    belongs_to :user
    has_many :game_tags
    has_many :games, through: :game_tags
end