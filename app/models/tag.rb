class Tag < ActiveRecord::Base
    belongs_to :user
    has_many :game_tags
    has_many :games, through: :game_tags

    def game_count_display
        if self.games.count == 0
            "No games tagged"
        elsif self.games.count == 1
            "1 game tagged"
        else
            "#{self.games.count.to_s} games tagged"
        end
    end
end