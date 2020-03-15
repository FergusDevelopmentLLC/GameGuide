class GameTagUser < ActiveRecord::Base
    belongs_to :game
    belongs_to :tag
    belongs_to :user
end