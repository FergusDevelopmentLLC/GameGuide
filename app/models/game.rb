class Game < ActiveRecord::Base
    belongs_to :user
    belongs_to :type
    has_many :comments
    has_many :game_tags
    has_many :tags, through: :game_tags
end